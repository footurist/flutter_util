import "package:flutter/material.dart";

class CoverSlider extends StatelessWidget {
  CoverSlider(
    this.covers,
    {
      this.title,
      this.subTitle,
      this.coverTitle,
      this.coverSubTitle,
      this.coverSubTitle2,
      this.onTitleTap,
      this.padding = 15,
      this.bottomPadding = false,
    }
  ): this._coverDescriptionPartBottomPadding = padding / 3;

  final List<Widget> covers;
  final Text title;
  final Text subTitle;
  final Text coverTitle;
  final Text coverSubTitle;
  final Text coverSubTitle2;
  final Function onTitleTap;
  final double padding;
  final double _coverDescriptionPartBottomPadding;
  final bool bottomPadding;

  

  Widget buildDescriptionTitleArrow() => Container(
    padding: EdgeInsets.only(bottom: 3),
    child: Icon(
      Icons.keyboard_arrow_right,
      color: Colors.black,
      size: 25,
    ),
  );

  Widget buildDescriptionTitle(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: _coverDescriptionPartBottomPadding),
          child: title,
        ),
        (onTitleTap != null)? buildDescriptionTitleArrow(): Container()
      ],
    );
  }
  
  Widget buildDescription(BuildContext context) {
    var myChildren = <Widget>[buildDescriptionTitle(context)];

    if (subTitle != null) myChildren.add(subTitle);

    return Container(
      padding: EdgeInsets.only(left: padding, bottom: padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: myChildren,
      ),
    );
  }
  
  List<Widget> addCoverDescriptionPart(List<Widget> myChildren, BuildContext context,
    Text text, {bool shouldPad = true}
  ) {
    if (text != null) myChildren.add(Container(
      padding: EdgeInsets.only(bottom: shouldPad? _coverDescriptionPartBottomPadding: 0),
      child: text,
    ));

    return myChildren;
  }

  Widget buildCover(BuildContext context, int index) {
    var myChildren = <Widget>[
      Container(
        child: covers[index],
        padding: EdgeInsets.only(bottom: _coverDescriptionPartBottomPadding),
      )
    ];

    myChildren = addCoverDescriptionPart(myChildren, context, coverTitle);
    myChildren = addCoverDescriptionPart(myChildren, context, coverSubTitle);
    myChildren = addCoverDescriptionPart(myChildren, context, coverSubTitle2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: myChildren,
    );
  }

  Widget buildSlider(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          covers.length, 
          (i) => Container(
            padding: EdgeInsets.only(
              left: padding,
              right: (i == covers.length - 1)? padding: 0
            ),
            child: buildCover(context, i),
          )
        ),
      ),
    );
  }

  List<Widget> buildMainColumnChildren(BuildContext context) {
    var myChildren = <Widget>[buildSlider(context)];

    if (title != null) myChildren.insert(0, buildDescription(context));

    return myChildren;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: padding).copyWith(
        bottom: bottomPadding? padding: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: buildMainColumnChildren(context),
      ),
    );
  }
}