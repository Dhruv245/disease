import 'package:equatable/equatable.dart';

class NewsQuery extends Equatable{
  final String sourceSite;
  final String url;
  final String imageUrl;

  const NewsQuery({
    this.sourceSite,
    this.url,
    this.imageUrl,
  });

  @override
  List<Object> get props => [
    sourceSite,
    url,
    imageUrl,
  ];

  factory NewsQuery.fromJson(dynamic json) {
    final source = json['source'];
    return NewsQuery(
      sourceSite: source['name'],
      url: json['url'],
      imageUrl: json['urlToImage'] ,
    );
  }
}