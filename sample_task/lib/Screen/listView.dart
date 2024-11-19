import 'package:Vajro/Bloc/apiEvents.dart';
import 'package:Vajro/Bloc/apiState.dart';
import 'package:Vajro/Model/apiResp.dart';
import 'package:Vajro/Screen/login.dart';
import 'package:Vajro/Screen/webView.dart';
import 'package:Vajro/Utils/colorUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstorage/localstorage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../Bloc/api_Bloc.dart'; // Import your ApiBloc

class ListingPage extends StatefulWidget {
  const ListingPage({super.key});

  @override
  State<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  final RefreshController _refreshController = RefreshController();
  List<Article> _cachedArticles = [];
  int _currentPage = 1;
  int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    // Fetch data when the widget initializes
    context
        .read<ApiBloc>()
        .add(FetchData(page: _currentPage, pageSize: _pageSize));
    _loadData();
  }

  void _loadData({bool isRefresh = false}) {
    if (isRefresh) {
      _currentPage = 1; // Reset to the first page
      _cachedArticles = []; // Clear cache
      context
          .read<ApiBloc>()
          .add(FetchData(page: _currentPage, pageSize: _pageSize));
    } else if (_currentPage > 0) {
      //Load more
      _currentPage++;
      context
          .read<ApiBloc>()
          .add(FetchData(page: _currentPage, pageSize: _pageSize));
    }
  }

  void _onRefresh() async {
    _loadData(isRefresh: true);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _loadData();
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              localStorage.setItem('isLoggedIn', "false");
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHomePage()),
                  (route) => false);
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(color: ColorUtils.primaryTitleTextColor),
            ),
          ),
          const SizedBox(
            width: 16,
          )
        ],
        title: const Text(
          'Listing Page',
          style: TextStyle(color: ColorUtils.primaryTitleTextColor),
        ),
        backgroundColor: ColorUtils.primaryColor,
      ),
      body: BlocBuilder<ApiBloc, ApiState>(
        builder: (context, state) {
          if (state is ApiLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ApiLoaded) {
            if (_currentPage == 1) {
              _cachedArticles = state.articles; //Refresh Case update cache
            } else {
              _cachedArticles
                  .addAll(state.articles); //Load More case append data
              if (state.articles.length < _pageSize) {
                //No more Data
                _currentPage = 0; //Stop making further load more calls
                _refreshController.loadNoData();
              }
            }
            return SmartRefresher(
                enablePullDown: true,
                enablePullUp: _currentPage > 0 ? true : false,
                primary: true,
                header: const WaterDropHeader(),
                footer: const ClassicFooter(),
                controller: _refreshController,
                // onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: ListView.builder(
                    itemCount: _cachedArticles.length,
                    itemBuilder: (context, index) {
                      return ItemCell(item: _cachedArticles[index]);
                    }));
          } else if (state is ApiError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(
                child:
                    Text('No data available')); // or a different default state
          }
        },
      ),
    );
  }
}

class ItemCell extends StatelessWidget {
  final Article item;

  const ItemCell({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    // Calculate image height based on width (maintain aspect ratio)
    final double imageHeight = item.image.height! *
        deviceWidth /
        item.image.width!; // Example: half the width

    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: SizedBox(
        width: deviceWidth,
        child: InkWell(
          onTap: () {
            // Handle tap, e.g., navigate to details page with bodyHtml
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => WebViewScreen(
                    htmlString: item.bodyHtml, title: item.title)));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12.0)),
                child: Image.network(
                  item.image.src ?? '', // Use network image, handle null
                  width: deviceWidth,
                  height: imageHeight,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      width: deviceWidth,
                      height: imageHeight,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/default_img.jpg', // Placeholder
                    width: deviceWidth,
                    height: imageHeight,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: ColorUtils.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      item.summaryHtml,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: ColorUtils.primaryTextColor,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      item.createdAt,
                      style:
                          const TextStyle(color: ColorUtils.secondaryTextColor),
                    ), // Use summaryHtml for description
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
