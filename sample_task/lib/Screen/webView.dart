import 'package:flutter/material.dart'; // Add this import
import 'package:webview_flutter/webview_flutter.dart'; // Add dependency for webview_flutter

class WebViewScreen extends StatefulWidget {
  final String htmlString;
  final String title;

  const WebViewScreen(
      {super.key, required this.htmlString, required this.title});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController controller;
  double progress = 0;

  final String htmlContent = """
    <div style='margin: 0px auto; padding: 0px; width: 95vw;'><img src=\"https://cdn.shopify.com/s/files/1/0528/4682/1565/articles/7E7A6226_copy.jpg?v=1659591982\" alt=\"img\" style='width:100%'/><p><span style=\"font-weight: 400;\">Despite the ultimate ease, comfort and modesty, styling an Abaya in extreme summers in UAE is a challenge for many of us. Therefore we are here to help you with some tips on how you can stay comfortable and modest by styling your Abaya the right way.</span></p>\n<br>\n<p><span style=\"font-weight: 400;\">No, we are not going to recommend you to wear a White Abaya. There is a lot more than you can do with your Abaya this summer. But first of all, you need to look for a seller that offers cheap Abaya Online. Because after reading this article you might need to go shopping for some major items. To help you, Hanayen offers different Abaya styles with accessories like head covers. Now let’s review the tips on how to style Abaya for summers. </span></p>\n<br><b>Choose Fabric Carefully </b>\n<p><span style=\"font-weight: 400;\">The first thing about styling for any season is considering the appropriate fabric. As you will be wearing Abaya on a layer of clothing, it should be breathable. Ensure you check the fabric quality and type before placing an order. Look for Abaya made of Cotton, Nida, or lightweight crepe. These are lightweight and can give sufficient coverage. As a result, you will not be sweating buckets underneath the Abaya as you step out this summer.</span></p>\n<br>\n<p><span style=\"font-weight: 400;\">You can also look for luxury Abaya made of 100% polyester. It the stylish as well as suitable for summer. You can find them in all styles, including Jilbab Abaya, burqa designs, Abaya Arab or even kaftan Abaya. However, here, you might need to look at the colours you choose for.</span></p>\n<br><b>Choosing the Right Colors</b><br>\n<p><span style=\"font-weight: 400;\">Ditch the blacks for this season. Although the fabric plays an important role in keeping you cool, the colour is nothing you should ignore. Make sure you have an open-front Abaya with more neutral tones – if white is not your colour. Whenever summer is at its peak, the first Abaya tip would be choosing colours that simultaneously complement the weather and your style. You can go for light greys, nudes, or earthy pestles. Other colour options include beige, blush pink, khakis, and florals.</span></p>\n<br>\n<p><span style=\"font-weight: 400;\">Besides the colours and fabric, you will need to take care of the Abaya's length, fit and style to make it work for you in the extreme heat. If you are unsure what to buy, explore Hanayen, it offers a wide range of options to choose from and order from.</span></p></div>
  """;

  // WebViewPlatform? platform;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int value) {
                setState(() {
                  progress = value / 100;
                });
                // Update loading bar.
              },
              onPageStarted: (String url) {},
              onPageFinished: (String url) {
                // Show a snackbar message when page loading is finished
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Page loaded successfully')),
                );
              },
              onHttpError: (HttpResponseError error) {
                // Show a snackbar message for HTTP errors
                _showErrorSnackBar("HTTP Error: ${error.response.toString()}");
              },
              onWebResourceError: (WebResourceError error) {
                // Show a snackbar message for web resource errors
                _showErrorSnackBar("Web Resource Error: ${error.description}");
              },
            ),
          )
          ..loadHtmlString("""
      <!DOCTYPE html>
        <html>
          <head><meta name="viewport" content="width=device-width, initial-scale=0.7"></head>
          <body style='"margin: 0; padding: 0;'>
            ${widget.htmlString}
          </body>
        </html>
      """)
        // ..loadRequest(Uri.parse('https://flutter.dev'))
        ;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      bottomNavigationBar: LinearProgressIndicator(
        value: progress,
      ),
      // body: WebViewWidget(controller: controller), // Use WebViewWidget
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          progress == 1 ? Container() : LinearProgressIndicator(value: progress)
        ],
      ),
      // Use WebViewWidget
    );
  }
}
