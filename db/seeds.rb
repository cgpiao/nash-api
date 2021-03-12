
currencies = %w[USD EUR GBP CNY JPY CHF CAD AUD NZD ZAR]
expense_categories = {
   'Transportation': %w[Taxi Bus Subway Train Plane],
   'Shopping': ['Books', 'Appliances', 'Digital' 'Cosmetics', 'Clothes', 'Accessories', 'Jewelry', 'Shoes', 'Smoke', 'Liquor'],
   'Food & Dining': %w[Breakfast Lunch Dinner Snacks Groceries Other],
   'Automobile': %w[Fuel Parking Maintenance Penalty Lease Other],
   'Bills': %w[Phone Water Electricity Gas Internet Loan Cable Maintenance Other],
   'Leisure': %w[Game Fitness/Sports Travel Party Concert Other],
   'Health Care': ['Dental', 'Eye Care', 'Pharmacy', 'Medical', 'Other'],
   'Insurance': %w[Car Home Health],
   'Other': ['Other']
}
income_categories = [
   'Investments', 'Child Supports', 'Rental', 'Salary & Wages', 'Social Security', 'Other'
]

unless Foundation.where(major: Foundation::MAJOR_CURRENCY).exists?
   Foundation.create(major: Foundation::MAJOR_CURRENCY, value: currencies.join(','))
end
unless Foundation.where(major: Foundation::MAJOR_EXPENSE).exists?
   expense_categories.each_pair do |key, value|
      Foundation.create(major: Foundation::MAJOR_EXPENSE, minor: key, value: value.join(','))
   end
end
unless Foundation.where(major: Foundation::MAJOR_INCOME).exists?
   Foundation.create(major: Foundation::MAJOR_INCOME, value: income_categories.join(','))
end
