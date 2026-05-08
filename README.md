# EasyQL

Generate SQL statements from the Dart language. This is useful for handling data before executing an SQL statement, or simply for convenience.

## Supported SQL dialect

| Dialect    | Status |
|:-----------|:------:|
| SQLite     | ✅     |
| PostgreSQL | ⌛     |

## Features

### DDL

- TRUNCATE
- DROP
- CREATE

### DML

- DELETE
- INSERT
- UPDATE

### DQL

- SELECT

### Aggregate functions

- COUNT
- SUM
- MIN
- MAX
- AVG

### Advanced functions

- COALESCE

### Compound operators

- UNION
- UNION ALL

## Getting started

```yaml
dependencies:
  easy_ql: <latest_version>
```

Done.

## Usage

First of all, **EasyQL** needs to be set up.

```dart
void main() {
    EasyQl().configureFor(SqliteConfiguration());
    // ...
}
```

So now it's possible to create SQL statements from Dart.

```dart
final sqlDelete = Drop.table(name).toString();

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
```

It's important to keep in mind that some SQL commands or statements aren't supported by all dialects. Therefore, the developer must be mindful of the code they write and the EasyQL configuration.

## Additional information

This package was created to standardize SQL queries across projects, due to an internal need.

Any contributions with good intentions are welcome.
