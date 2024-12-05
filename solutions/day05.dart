import '../utils/index.dart';

class Day05 extends GenericDay {
  Day05() : super(5);

  late List<String> pageOrders;
  late List<List<String>> pagesToPrint;
  @override
  void parseInput() {
    final inputTool = InputUtil(5);
    final paragraphs = inputTool.getParagraphLines();
    // first pargraph is page orders

    // second paragraph is needed pages
    pageOrders = paragraphs[0];
    pagesToPrint = paragraphs[1].map((e) => e.split(',')).toList();
    print('pageOrders: $pageOrders');
    print('pagesToPrint: $pagesToPrint');
  }

  @override
  int solvePart1() {
    parseInput();
    final pageSetValidity = <bool>[];

    pagesToPrint.forEach(
      (pageSet) {
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
            if (pageOrders.contains('$currentPage|$nextPage')) {
              pageValid &= true;
              print(
                  'currentPage: $currentPage nextPage: $nextPage setting true');
            } else {
              pageValid = false;
              print(
                  'currentPage: $currentPage nextPage: $nextPage pageValid: $pageValid');
            }
            // could break out after one bad page but I'm lazy
          }
          print('currentPage: $currentPage pagevalid: $pageValid');
          pageSetValid &= pageValid;
          // could quit looking at this page set if false but I'm lazy
        }
        pageSetValidity.add(pageSetValid);
        print('pageset: $pageSet pagesetvalid: $pageSetValid');
      },
    );
    print('$pageSetValidity');
    var pageSum = 0;
    for (var i = 0; i < pageSetValidity.length; i++) {
      if (pageSetValidity[i]) {
        // find the middle of each page list that was valid
        final middlePageIndex = pagesToPrint[i].length ~/ 2;
        pageSum += int.parse(pagesToPrint[i][middlePageIndex]);
      }
    }

    return pageSum;
  }

  @override
  int solvePart2() {
    return 0;
  }
}
