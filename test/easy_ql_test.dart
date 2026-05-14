import 'package:easy_ql/easy_ql.dart';
import 'package:test/test.dart';

void main() {
  group('SQLite', () {
    EasyQl().configureFor(SqliteConfiguration());

    group('DDL', () {
      test('TRUNCATE', () {
        try {
          final _ = const Truncate('table_name').toString();
        } catch (e) {
          expect(e, isUnimplementedError);
          print((e as UnimplementedError).message);
        }
      });

      test('DROP INDEX', () {
        const name = 'index_name';

        final sql1 = Drop.index(name).toString();
        const eSql1 = 'DROP INDEX IF EXISTS [index_name]';
        expect(sql1, eSql1);
        print(eSql1);

        final sql2 = Drop.index(
          name,
          ifExists: false,
        ).toString();
        const eSql2 = 'DROP INDEX [index_name]';
        expect(sql2, eSql2);
        print(eSql2);
      });

      test('DROP VIEW', () {
        const name = 'view_name';

        final sql = Drop.view(name).toString();
        const eSql = 'DROP VIEW IF EXISTS [view_name]';
        expect(sql, eSql);
        print(eSql);
      });

      test('DROP TABLE', () {
        const name = 'table_name';

        final sql = Drop.table(name).toString();
        const eSql = 'DROP TABLE IF EXISTS [table_name]';
        expect(sql, eSql);
        print(eSql);
      });

      test('CREATE INDEX', () {
        const name = 'index_name';
        const table = 'table_name';

        final sql = Create.index(
          name,
          onTable: table,
          columns: {'c1', 'c2'},
        ).toString();
        const eSql = 'CREATE INDEX [index_name]\nON [table_name] ([c1], [c2])';
        expect(sql, eSql);
        print(eSql);
      });

      test('CREATE VIEW', () {
        const name = 'view_name';
        const subquery = 'SELECT * FROM [table_name]';

        final sql = Create.view(
          name,
          subquery: subquery,
        ).toString();
        const eSql = 'CREATE VIEW [view_name] AS\n$subquery';
        expect(sql, eSql);
        print(eSql);
      });

      test('CREATE TABLE', () {
        const name = 'table_name';

        final sql = Create.table(
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
              references: ForeignKeyReference('referenced_table', 'rc1'),
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
        // const eSql = 'CREATE VIEW [view_name] AS\n$subquery';
        expect(sql, isA<String>());
        print(sql);
      });
    });

    test('CREATE TABLE FROM SUBQUERY', () {
      const name = 'table_name';

      final sql = Create.tableFromSubquery(
        table: name,
        subquery: 'SELECT * FROM [other]',
      ).toString();
      // const eSql = 'CREATE VIEW [view_name] AS\n$subquery';
      expect(sql, isA<String>());
      print(sql);
    });

    test('DELETE', () {
      const name = 'table_name';

      final sql1 = Delete.from(name).toString();
      print(sql1);

      final sql2 = Delete.from(
        name,
        where: And(
          [
            const Column('asd').equals('cut'),
            const Column('qwe').isNotNull(),
          ],
        ),
      ).toString();
      print(sql2);

      expect(sql2, isA<String>());
    });

    test('INSERT DEFAULT VALUES', () {
      const name = 'table_name';

      final sql = Insert.defaultValuesInto(
        name,
        returning: [],
      ).toString();

      print(sql);
      expect(sql, isA<String>());
    });

    test('INSERT FROM SUBQuery', () {
      const name = 'table_name';

      final sql = Insert.fromSubqueryInto(
        name,
        subquery: 'SELECT * FROM [other]',
        onConflict: OnConflict(
          columns: {'id'},
          then: DoUpdate(
            values: {'name': 'John'},
            where: const Column('id').equals(123),
          ),
        ),
      ).toString();

      print(sql);
      expect(sql, isA<String>());
    });

    test('INSERT (classic)', () {
      const name = 'table_name';

      final sql = Insert.into(
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

      print(sql);
      expect(sql, isA<String>());
    });

    test('UPDATE', () {
      const name = 'table_name';

      final sql = Update(
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

      print(sql);
      expect(sql, isA<String>());
    });

    test('SELECT', () {
      final sql = Select.from(
        't1',
        joins: [
          Join.inner(
            'table_2',
            alias: 't2',
            on: const Column('id').equalsColumn('id'),
          ),
        ],
        columns: [
          AllFields(from: 't1'),
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

      print(sql);
      expect(sql, isA<String>());
    });
  });
}
