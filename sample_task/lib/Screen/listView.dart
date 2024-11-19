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

  @override
  void initState() {
    super.initState();
    // Fetch data when the widget initializes
    context.read<ApiBloc>().add(FetchData());
  }

  void _onRefresh() async {
    context.read<ApiBloc>().add(FetchData());
    _refreshController.refreshCompleted();
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
          SizedBox(
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
            return SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                primary: true,
                header: const WaterDropHeader(),
                footer: const ClassicFooter(),
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: ListView.builder(
                    itemCount: state.articles.length,
                    itemBuilder: (context, index) {
                      return ItemCell(item: state.articles[index]);
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
                builder: (context) =>
                    WebViewScreen(htmlString: item.bodyHtml)));
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
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: ColorUtils.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      item.author,
                      style:
                          const TextStyle(color: ColorUtils.secondaryTextColor),
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
