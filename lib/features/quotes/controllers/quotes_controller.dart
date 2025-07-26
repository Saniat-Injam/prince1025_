import 'package:get/get.dart';

class QuotesController extends GetxController {
  // Current selected tab
  final RxInt selectedTabIndex = 0.obs;

  // Tab titles
  final List<String> tabs = ['All','Motivational', 'Quotes', 'Courses'];

  // Map to track liked state of each quote
  final RxMap<String, bool> likedQuotes = <String, bool>{}.obs;

  // Select tab
  void selectTab(int index) {
    selectedTabIndex.value = index;
  }

  // Toggle quote like and save to favorites
  void toggleQuoteLike(String quote, String author) {
    final quoteKey = '$quote|$author';
    likedQuotes[quoteKey] = !(likedQuotes[quoteKey] ?? false);

    // Update storage or notify other controllers about the change
    update(); // This will notify any listening widgets
  }

  // Check if quote is liked
  bool isQuoteLiked(String quote, String author) {
    final quoteKey = '$quote|$author';
    return likedQuotes[quoteKey] ?? false;
  }

  // Get favorite quotes for profile screen
  List<Map<String, String>> get favoriteQuotes {
    List<Map<String, String>> favorites = [];

    for (String key in likedQuotes.keys) {
      if (likedQuotes[key] == true) {
        final parts = key.split('|');
        if (parts.length == 2) {
          favorites.add({'quote': parts[0], 'author': parts[1]});
        }
      }
    }

    return favorites;
  }

  // Get the latest favorite quote for profile screen
  Map<String, String>? get latestFavoriteQuote {
    final favorites = favoriteQuotes;
    return favorites.isNotEmpty ? favorites.last : null;
  }

  // Get motivational quotes data (only one for free users)
  List<Map<String, String>> get motivationalQuotes => [
    {
      'quote':
          'The only limit to our realization of tomorrow will be our doubts of today',
      'author': 'Franklin D. Roosevelt',
    },
    // Additional quotes for premium users
    {
      'quote':
          'Success is not final, failure is not fatal: it is the courage to continue that counts',
      'author': 'Winston Churchill',
    },
    {
      'quote': 'The way to get started is to quit talking and begin doing',
      'author': 'Walt Disney',
    },
    {
      'quote': 'Don\'t be afraid to give up the good to go for the great',
      'author': 'John D. Rockefeller',
    },
  ];

  // Get quotes category data
  List<Map<String, String>> get quotesCategory => [
    {
      'quote': 'Believe you can and you\'re halfway there',
      'author': 'Theodore Roosevelt',
    },
    {
      'quote':
          'It is during our darkest moments that we must focus to see the light',
      'author': 'Aristotle',
    },
    {
      'quote':
          'The future belongs to those who believe in the beauty of their dreams',
      'author': 'Eleanor Roosevelt',
    },
  ];

  // Get courses category data
  List<Map<String, String>> get coursesCategory => [
    {
      'quote':
          'Education is the most powerful weapon which you can use to change the world',
      'author': 'Nelson Mandela',
    },
    {
      'quote':
          'Live as if you were to die tomorrow. Learn as if you were to live forever',
      'author': 'Mahatma Gandhi',
    },
    {
      'quote': 'The more that you read, the more things you will know',
      'author': 'Dr. Seuss',
    },
  ];

  // Get all quotes
  List<Map<String, String>> get allQuotes => [
    ...motivationalQuotes,
    ...quotesCategory,
    ...coursesCategory,
  ];

  // Get quotes based on selected tab (show only first quote per section for free users)
  List<Map<String, String>> getCurrentQuotes() {
    List<Map<String, String>> quotes;
    switch (selectedTabIndex.value) {
      case 0:
        return allQuotes
            .take(3)
            .toList(); // Show only first quote from each category
      case 1:
        quotes = motivationalQuotes;
        break;
      case 2:
        quotes = quotesCategory;
        break;
      case 3:
        quotes = coursesCategory;
        break;
      default:
        quotes = allQuotes;
    }

    // For individual tabs, show only the first quote
    return quotes.take(1).toList();
  }

  // Get grouped quotes for "All" tab - show only first quote from each section
  List<Map<String, dynamic>> get groupedQuotes => [
    {
      'type': 'section',
      'title': 'Motivational',
      'quotes': motivationalQuotes.take(1).toList(),
    },
    {
      'type': 'section',
      'title': 'Quotes',
      'quotes': quotesCategory.take(1).toList(),
    },
    {
      'type': 'section',
      'title': 'Courses',
      'quotes': coursesCategory.take(1).toList(),
    },
  ];

  // Check if current tab is "All" tab
  bool get isAllTabSelected => selectedTabIndex.value == 0;

  // Navigate to subscription screen
  void navigateToSubscription() {
    Get.toNamed('/subscription');
  }
}
