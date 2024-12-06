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

    // second paragraph is needed pages
    pageOrderPolicies = paragraphs[0];
    pagesToPrint = paragraphs[1].map((e) => e.split(',')).toList();
    print('pageOrders: $pageOrderPolicies');
    print('pagesToPrint: $pagesToPrint');
  }

  @override
  int solvePart1() {
    return 0;
    parseInput();
    final pageSetValidity = calcPageSetValidity(
        dataSet: pagesToPrint, pageOrderRules: pageOrderPolicies);
    print('$pageSetValidity');
    return middlePagesOf(
      dataSet: pagesToPrint,
      validityMarkers: pageSetValidity,
      targetState: true,
    );
  }

  @override
  int solvePart2() {
    parseInput();
    final pageSetValidity = calcPageSetValidity(
        dataSet: pagesToPrint, pageOrderRules: pageOrderPolicies);
    print('$pageSetValidity');
    final reorderedSet = reorderAllSetsToValid(
      dataSet: pagesToPrint,
      pageOrderRules: pageOrderPolicies,
      validitySet: pageSetValidity,
    );
    print('reorderedSets $reorderedSet');
    return middlePagesOf(
      dataSet: reorderedSet,
      validityMarkers: pageSetValidity,
      targetState: false,
    );
  }

  /// figure out which page sets are valid
  List<bool> calcPageSetValidity(
      {required List<List<String>> dataSet,
      required List<String> pageOrderRules}) {
    final pageSetValidity = <bool>[];

    for (final pageSet in dataSet) {
      print('examining pageSet: $pageSet');
      var pageSetValid = true;
      // examine each page
      for (var index = 0; index < pageSet.length - 1; index++) {
        var pageValid = true;
        final currentPage = pageSet[index];
        // sweep across all the pages after it - they all must be valid
        for (var index2 = index + 1; index2 < pageSet.length; index2++) {
          final nextPage = pageSet[index2];
          print('currentPage $currentPage : nextPage $nextPage');
          // could skip if !pageValid already from previous pass
          if (pageOrderPolicies.contains('$currentPage|$nextPage')) {
            pageValid &= true;
            print('currentPage: $currentPage nextPage: $nextPage '
                'setting true');
          } else {
            pageValid = false;
            print('currentPage: $currentPage nextPage: $nextPage '
                'pageValid: $pageValid');
          }
          // could break out after one bad page but I'm lazy
        }
        print('currentPage: $currentPage pagevalid: $pageValid');
        pageSetValid &= pageValid;
        // could quit looking at this page set if false but I'm lazy
      }
      pageSetValidity.add(pageSetValid);
      print('pageset: $pageSet pagesetvalid: $pageSetValid');
    }
    print('$pageSetValidity');
    return pageSetValidity;
  }

  /// return the sum of the middle pages
  int middlePagesOf(
      {required List<List<String>> dataSet,
      required List<bool> validityMarkers,
      required bool targetState}) {
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

  /// Reorder the pages in all the page sets to be in valid orders
  /// return them all so we get a list of page sets that aref all valid
  List<List<String>> reorderAllSetsToValid({
    required List<List<String>> dataSet,
    required List<String> pageOrderRules,
    required List<bool> validitySet,
  }) {
    final allValidPageSets = <List<String>>[];
    for (var i = 0; i < dataSet.length; i++) {
      if (validitySet[i]) {
        // no changes required
        allValidPageSets.add(dataSet[i]);
      } else {
        // shuffle the invalid set
        allValidPageSets.add(
            reorderOneSet(pageSet: dataSet[i], pageOrderRules: pageOrderRules));
      }
    }
    return allValidPageSets;
  }

  // sort this one set of pages using the custom comparator and return it
  List<String> reorderOneSet({
    required List<String> pageSet,
    required List<String> pageOrderRules,
  }) {
    // sort the page set based on the transitions mappings
    //print('transitions: $transitions');
    final sortedPageSet =
        pageSet.sorted((a, b) => compareViaTransitions(a, b, pageOrderRules));
    //print('sorted transitions $sortedPageSet');
    // do some graph navigation thing
    // I GIVE UP
    return sortedPageSet;
  }

  /// custom comparitor that uses the transition map as its guide.
  int compareViaTransitions(String a, String b, List<String> transitions) {
    if (transitions.contains('$a|$b')) return -1;
    if (transitions.contains('$b|$a')) return 1;
    return 0;
  }
}
