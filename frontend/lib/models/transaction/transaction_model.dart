class TransactionModel {
  final String title;
  final String description;
  final String date;
  final String amount;
  final String image;

  TransactionModel({
    required this.description,
    required this.title,
    required this.date,
    required this.amount,
    required this.image,
  });
}

List<TransactionModel> transactionsData = [
  TransactionModel(
    title: 'Fund wallet',
    description: 'to Jackson Botox',
    amount: '\$10560,00',
    date: '4 hours ago',
    image: 'assets/images/google.png',
  ),
  TransactionModel(
    title: 'Transfer',
    description: 'to James Brown',
    amount: '\$289,00',
    date: '4th March, 2022 at 05:30 pm',
    image: 'assets/images/google.png',
  ),
  TransactionModel(
    title: 'Transfer',
    description: 'to Jacob Jons',
    amount: '\$289,00',
    date: '19th March, 2022 at 04:30 pm',
    image: 'assets/images/google.png',
  ),
  TransactionModel(
    title: 'Transfer',
    description: 'to James David',
    amount: '\$740,00',
    date: '30th March, 2022 at 04:30 pm',
    image: 'assets/images/google.png',
  ),
  TransactionModel(
    title: 'Fund wallet',
    description: 'to Jackson Botox',
    amount: '\$650,00',
    date: '4 hours ago',
    image: 'assets/images/google.png',
  ),
  TransactionModel(
    title: 'Transfer',
    description: 'to James Brown',
    amount: '\$500,00',
    date: '4th March, 2022 at 05:30 pm',
    image: 'assets/images/google.png',
  ),
  TransactionModel(
    title: 'Transfer',
    description: 'to Jacob Jons',
    amount: '\$2700,00',
    date: '19th March, 2022 at 04:30 pm',
    image: 'assets/images/google.png',
  ),
  TransactionModel(
    title: 'Transfer',
    description: 'to James David',
    amount: '\$200,00',
    date: '30th March, 2022 at 04:30 pm',
    image: 'assets/images/google.png',
  ),
];
