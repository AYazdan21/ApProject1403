import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

class NewsTab extends StatefulWidget {
  @override
  _NewsTabState createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  final List<Map<String, String>> newsList = [
    {
      'url': 'https://news.sbu.ac.ir/%D9%88%D8%B1%D8%B2%D8%B4%DB%8C',
    },
    {
      'url': 'https://news.sbu.ac.ir/%D9%BE%D8%A7%D8%B1%DA%A9-%D8%B9%D9%84%D9%85-%D9%88-%D9%81%D9%86%D8%A7%D9%88%D8%B1%DB%8C',
    },
    {
      'url': 'https://news.sbu.ac.ir/%D8%A7%D8%AF%D8%A7%D8%B1%DB%8C-%D9%88-%D8%B3%D8%A7%D8%B2%D9%85%D8%A7%D9%86%DB%8C',
    },
    {
      'url': 'https://news.sbu.ac.ir/%D8%A2%D9%85%D9%88%D8%B2%D8%B4%DB%8C',
    },
    {
      'url': 'https://news.sbu.ac.ir/%D8%AF%D8%A7%D9%86%D8%B4%D8%AC%D9%88%DB%8C%DB%8C',
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchNewsData();
  }

  Future<void> _fetchNewsData() async {
    List<Future<Map<String, String>>> futures = newsList.map((news) async {
      final title = await _fetchTitle(news['url']!);
      final description = await _fetchDescription(news['url']!);
      return {
        'url': news['url']!,
        'title': title,
        'description': description,
      };
    }).toList();

    List<Map<String, String>> updatedNewsList = await Future.wait(futures);

    setState(() {
      for (var updatedNews in updatedNewsList) {
        for (var news in newsList) {
          if (news['url'] == updatedNews['url']) {
            news['title'] = updatedNews['title']!;
            news['description'] = updatedNews['description']!;
          }
        }
      }
    });
  }

  Future<String> _fetchTitle(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var document = html_parser.parse(response.body);
        var title = document.getElementsByTagName('title').first.text;
        return title;
      } else {
        throw Exception('Failed to load web page');
      }
    } catch (e) {
      return 'Failed to fetch title';
    }
  }

  Future<String> _fetchDescription(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var document = html_parser.parse(response.body);
        var descriptionMeta = document.querySelector('meta[name="description"]');
        var description = descriptionMeta?.attributes['content'] ?? 'No description available';
        return description;
      } else {
        throw Exception('Failed to load web page');
      }
    } catch (e) {
      return 'Failed to fetch description';
    }
  }

  void _showNewsDialog(BuildContext context, String title, String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text('Do you want to read more?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // _launchURL(url);
                final linkToOpen = Uri.parse(url);
                await launchUrl(linkToOpen);
                Navigator.of(context).pop();

              },
              child: Text('Open'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('Could not launch $url');
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: newsList.length,
      itemBuilder: (context, index) {
        final news = newsList[index];
        return Card(
          margin: EdgeInsets.all(15),
          color: Color(0xFF2F1E9D),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset(
                    'images/sbuDoor.png',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  news['title'] ?? 'Loading...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  news['description'] ?? 'Loading description...',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    if (news['title'] != null && news['url'] != null) {
                      _showNewsDialog(context, news['title']!, news['url']!);
                    }
                  },
                  child: Text(
                    'Read More',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
