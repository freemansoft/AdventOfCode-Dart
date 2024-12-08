import '../utils/index.dart';

class Day05 extends GenericDay {
  Day05() : super(5);

  late List<String> pageOrderPolicies;
  late List<List<String>> pagesToPrint;
  @override
  void parseInput() {
    final inputTool = InputUtil(5);
    final paragraphs = inputTool.getParagraphLines();
    // first pargraph is page orders
    pageOrderPolicies = paragraphs[0];
    // second paragraph is needed pages
    pagesToPrint = paragraphs[1].map((e) => e.split(',')).toList();
    //print('pageOrders: $pageOrderPolicies');
    //print('pagesToPrint: $pagesToPrint');
  }

  @override
  int solvePart1() {
    parseInput();
    // get the map of sets that are valid
    final pageSetValidity = calcPageSetValidity(
      dataSet: pagesToPrint,
      pageOrderRules: pageOrderPolicies,
    );
    // now add up the middle pages of those that are valid
    return middlePagesOf(
      dataSet: pagesToPrint,
      validityMarkers: pageSetValidity,
      targetState: true,
    );
  }

  @override
  int solvePart2() {
    parseInput();

    // get the map of sets that are valid in the read in dataset
    final pageSetValidity = calcPageSetValidity(
      dataSet: pagesToPrint,
      pageOrderRules: pageOrderPolicies,
    );
    // create a data set that has everything reordered correctly
    final reorderedSet =
        sortAllSets(dataSet: pagesToPrint, pageOrderRules: pageOrderPolicies);

    // the original validity map tells which ones we changed and we add them
    return middlePagesOf(
      dataSet: reorderedSet,
      validityMarkers: pageSetValidity,
      targetState: false,
    );
  }

  /// figure out which page sets are valid
  /// Used for problem answer discrimination
  List<bool> calcPageSetValidity({
    required List<List<String>> dataSet,
    required List<String> pageOrderRules,
  }) {
    final sortedSets =
        sortAllSets(dataSet: dataSet, pageOrderRules: pageOrderRules);

    final pageSetValidity = <bool>[];
    for (var i = 0; i < dataSet.length; i++) {
      pageSetValidity.add(dataSet[i].equals(sortedSets[i]));
    }
    return pageSetValidity;
  }

  /// return the sum of the middle pages
  int middlePagesOf({
    required List<List<String>> dataSet,
    required List<bool> validityMarkers,
    required bool targetState,
  }) {
    var pageSum = 0;
    for (var i = 0; i < validityMarkers.length; i++) {
      if (validityMarkers[i] == targetState) {
        // find the middle of each page list that was valid
        final middlePageIndex = dataSet[i].length ~/ 2;
        pageSum += int.parse(dataSet[i][middlePageIndex]);
      }
    }

    return pageSum;
  }

  /// brute force just force sort everything
  /// by sorting each one no matter what the state
  List<List<String>> sortAllSets({
    required List<List<String>> dataSet,
    required List<String> pageOrderRules,
  }) {
    final allValidPageSets = <List<String>>[];
    for (var i = 0; i < dataSet.length; i++) {
      allValidPageSets.add(
        reorderOneSet(pageSet: dataSet[i], pageOrderRules: pageOrderRules),
      );
    }
    return allValidPageSets;
  }

  // sort this one set of pages using the custom comparator and return it
  List<String> reorderOneSet({
    required List<String> pageSet,
    required List<String> pageOrderRules,
  }) {
    // sort the page set based on the transitions mappings
    final sortedPageSet =
        pageSet.sorted((a, b) => compareViaTransitions(a, b, pageOrderRules));
    return sortedPageSet;
  }

  /// custom comparitor that uses the transition map as its guide.
  int compareViaTransitions(String a, String b, List<String> transitions) {
    if (transitions.contains('$a|$b')) return -1;
    if (transitions.contains('$b|$a')) return 1;
    return 0;
  }
}
