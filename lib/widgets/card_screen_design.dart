import 'package:flutter/material.dart';

import '../models/items_model.dart';

class CardScreenDesign extends StatefulWidget {

  final Items? model;
  BuildContext? context;

  final List<int>?  separateItemQuentitiesList;

   CardScreenDesign({Key? key, this.context, this.model, this.separateItemQuentitiesList}) : super(key: key);

  @override
  State<CardScreenDesign> createState() => _CardScreenDesignState();
}

class _CardScreenDesignState extends State<CardScreenDesign> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Image.network(widget.model?.thumbnailUrl ?? 'resim alınmıyor'),//Image.asset(image),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DefaultTextStyle(
            style: const TextStyle(color: Colors.black54),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.model?.title ?? ' title alınmıyor',
                  //title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(widget.model?.shortInfo ?? 'info alınmıyor', maxLines: 2,
                    overflow: TextOverflow.ellipsis,),
                  //child: Text("Shortbread, chocolate turtle cookies, and red velvet.",
                  // maxLines: 2,
                  // overflow: TextOverflow.ellipsis,

                ),
                Row(
                  children: [
                    Text(widget.separateItemQuentitiesList.toString() ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: CircleAvatar(
                        radius: 2,
                        backgroundColor: Colors.black38,
                      ),
                    ),
                    const Text("Chinese"),
                    const Spacer(),
                    Text(
                      "${widget.model?.price}\u{20BA}",
                      //"$price",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF22A45D),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
