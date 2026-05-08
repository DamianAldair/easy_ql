import 'package:easy_ql/easy_ql.dart';

void main() {
  EasyQl().configureFor(SqliteConfiguration());

  const name = 'table_name';

  final sqlDelete = Drop.table(name).toString();
  print(sqlDelete);
  // DROP TABLE IF EXISTS [table_name]

  final sqlCreate = Create.table(
    name,
    columns: {
      const TableColumn(
        'c1',
        type: DataType.autoincrementalInteger,
        primaryKey: true,
        primaryKeyOrder: OrderType.ascending,
        primaryKeyConflictClause: ConflictClause.fail,
      ),
      const TableColumn(
        'c2',
        type: DataType.varchar,
        precision: 255,
        unique: true,
        uniqueConflictClause: ConflictClause.fail,
        defaultValue: Default(' '),
        nullable: false,
        nullConflictClause: ConflictClause.abort,
      ),
      const TableColumn(
        'fk1',
        type: DataType.bigInteger,
        nullConflictClause: ConflictClause.rollback,
        references: ForeignKeyReference(
          referencedTable: 'referenced_table',
          referencedColumns: {'rc1'},
        ),
      ),
      const TableColumn(
        'fk2',
        type: DataType.varchar,
      ),
    },
    constraints: [
      ForeignKey(
        name: 'e_fk',
        columns: {'fk2'},
        referencedTable: 'referenced_table',
        referencedColumns: {'rc2'},
        onUpdate: ForeignKeyAction.cascade,
        onDelete: ForeignKeyAction.cascade,
      ),
      Check(const Column('c2').notEquals('asd')),
    ],
  ).toString();
  print(sqlCreate);
  // CREATE TABLE [table_name] (
  //       [c1] INTEGER PRIMARY KEY ASC ON CONFLICT FAIL AUTOINCREMENT NOT NULL,
  //       [c2] VARCHAR (255) NOT NULL ON CONFLICT ABORT UNIQUE ON CONFLICT FAIL DEFAULT ' ',
  //       [fk1] INTEGER NOT NULL ON CONFLICT ROLLBACK REFERENCES [referenced_table] ([rc1]),
  //       [fk2] VARCHAR NOT NULL,
  //       CONSTRAINT [e_fk] FOREIGN KEY ([fk2]) REFERENCES [referenced_table] ([rc2]) ON DELETE CASCADE ON UPDATE CASCADE,
  //       CHECK ([c2] <> 'asd')
  // )

  final sqlInsert = Insert.into(
    name,
    columns: {'name', 'job', 'age'},
    values: [
      ['John', 'Designer', 23],
      ['Mary', 'Programmer', 24],
      ['Tom', 'CEO', 54],
    ],
    onConflict: const OnConflict(then: DoNothing()),
    returning: ['name', 'job'],
  ).toString();
  print(sqlInsert);
  // INSERT INTO [table_name]
  // ([name], [job], [age])
  // VALUES
  // ('John', 'Designer', 23),
  // ('Mary', 'Programmer', 24),
  // ('Tom', 'CEO', 54)
  // ON CONFLICT DO NOTHING
  // RETURNING [name], [job]

  final sqlUpdate = Update(
    name,
    or: ConflictClause.replace,
    values: {
      'name': 'John',
      'job': 'Developer',
      'age': 30,
    },
    where: const Column('id').equals(123),
    returning: ['id'],
  ).toString();
  print(sqlUpdate);
  // UPDATE OR REPLACE [table_name] SET
  // [name] = 'John',
  // [job] = 'Developer',
  // [age] = 30
  // WHERE
  // [id] = 123
  // RETURNING [id]

  final sqlSelect = Select.from(
    't1',
    joins: [
      Join.inner(
        'table_2',
        alias: 't2',
        on: const Column('id').equalsColumn('id'),
      ),
    ],
    columns: [
      const AllFields(),
      Count(alias: 'count'),
    ],
    distinct: true,
    where: const Column('dt').greaterThanOrEquals(DateTime.now()),
    groupBy: ['name', 'last_name'],
    having: const Column('incidents').equals(0),
    orderBy: [const OrderBy('name', OrderType.ascending)],
    limit: 100,
    skip: 50,
  ).toString();
  print(sqlSelect);
  // SELECT
  // DISTINCT
  // *,
  // COUNT(*) AS [count]
  // FROM
  // [t1]
  // INNER JOIN [table_2] AS [t2] ON [id] = [id]
  // WHERE
  // [dt] >= DATETIME('2026-05-08T14:50:43.440984')
  // GROUP BY [name], [last_name]
  // HAVING
  // [incidents] = 0
  // ORDER BY [name] ASC
  // LIMIT 100
  // OFFSET 50
}
