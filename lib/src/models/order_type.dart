/// Used to sort the data.
enum OrderType {
  /// The ASC command is used to sort the data returned in ascending order.
  ascending,

  /// The DESC command is used to sort the data returned in descending order.
  descending,
  ;

  @override
  String toString() => switch (this) {
        OrderType.ascending => 'ASC',
        OrderType.descending => 'DESC',
      };
}
