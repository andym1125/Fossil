import 'package:flutter/material.dart';
import 'package:fossil/fossil.dart';
import 'package:fossil/single_post/single_post.dart';
import 'package:fossil/home_post/post_class.dart';

class IconsList extends StatefulWidget {

  final bool isFavourited;
  final String id;
  final int reblogsCount;
  final bool isReblogged;
  final Fossil fossil;
  final int repliesCount;
  final Post post;

  const IconsList({super.key, required this.fossil, required this.isFavourited, required this.id, required this.reblogsCount, required this.isReblogged, required this.repliesCount, required this.post});

  @override
  State<IconsList> createState() => _IconsListState();
}

class _IconsListState extends State<IconsList> {

  bool _isFavourited = false;
  bool _isReblogged = false;

  @override
  void initState() {
    super.initState();
    _isFavourited = widget.isFavourited;
    _isReblogged = widget.isReblogged;
  }

  Future<void> _toggleFavoriteStatus() async {
    if (_isFavourited) {
      try {
        await widget.fossil.destroyFavorite(widget.id);
        setState(() {
          _isFavourited = false;
        });
      } catch(e) {
        debugPrint('Error: $e');
      }
    } else {
      try {
        await widget.fossil.favorite(widget.id);
        setState(() {
          _isFavourited = true;
        });
      } catch (e) {
        debugPrint('Error: $e');
      }
    }
  }

  Future<void> _toggleReblogStatus() async {
    if (_isReblogged) {
      try {
        await widget.fossil.destroyReblog(widget.id);
        setState(() {
          _isReblogged = false;
        });
      } catch(e) {
        debugPrint('Error: $e');
      }
    } else {
      try {
        await widget.fossil.createReblog(widget.id);
        setState(() {
          _isReblogged = true;
        });
      } catch (e) {
        debugPrint('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(
          onPressed: () {
            Navigator.push (
              context,
              MaterialPageRoute(builder: (context) => SinglePost(fossil: widget.fossil, post: widget.post))
            );
          }, 
          icon: widget.repliesCount > 0
            ? Row(
              children: [
                const Icon(Icons.comment_rounded),
                const SizedBox(width: 3),
                Text('${widget.repliesCount}')
              ],
            )
            : const Icon(Icons.comment_rounded)
        ),
        IconButton(
          onPressed: _toggleReblogStatus,
          icon: widget.isReblogged == true
            ? Row(
              children: [
                const Icon(Icons.rocket, color: Colors.blue),
                if(widget.reblogsCount > 0) Text('${widget.reblogsCount}')
              ],
            )
            : Row(
              children: [
                if (widget.isReblogged == false) const Icon(Icons.rocket_outlined),
                if(widget.reblogsCount > 0) Text('${widget.reblogsCount}')
              ],
            )
          //icon: const Icon(Icons.rocket_outlined)
        ),
        IconButton(
          onPressed: _toggleFavoriteStatus,
          icon: widget.isFavourited == true
            ? const Icon(Icons.favorite, color: Colors.amber)
            : const Icon(Icons.favorite_border)
        ),
        IconButton(
          onPressed: () {

          }, 
          icon: const Icon(Icons.share_outlined)
        )
      ],
    );
  }
}