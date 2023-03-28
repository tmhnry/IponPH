class ControllerNames {
  static const String enterpriseName = 'Enterprise / Business Title';
  static const String enterpriseAddressName = 'Enterprise Address';
  static const String enterpriseContactNumberName =
      'Enterprise Tel / Phone Number';
  static const String enterpriseEmailName = 'Enterprise Email Address';
  static const String customerName = 'Customer';
  static const String discountName = 'Discount';
  static const String creditByCashName = 'Credit (Cash)';
  static const String creditCardName = 'Credit Card No.';
  static const String itemIDName = 'Identifier';
  static const String itemTypeName = 'Type';
  static const String itemName = 'Name';
  static const String itemDistributorName = 'Supplier';
  static const String itemPriceName = 'Sales Price';
  static const String itemCostName = 'Purchase Price';
  static const String itemQuantityName = 'Quantity';
}

class EnterpriseSections {
  static const List<String> sectionNames = [
    delivery,
    stocks,
    accounting,
    hr,
    associations,
  ];
  static const String delivery = 'DELIVERY';
  static const String stocks = 'STOCKS';
  static const String accounting = 'ACCOUNTING';
  static const String hr = 'HR';
  static const String associations = 'ASSOCIATIONS';
}

class DailyDistributionScreenTabs {
  static const List<String> tabNames = [
    approvedDailyDistribution,
    pendingDailyDistribution,
  ];
  static const String approvedDailyDistribution = 'Approved';
  static const String pendingDailyDistribution = 'Pending';
}
