import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemCard extends StatelessWidget {
  final String name;
  final int age;
  //// Pointer to Update Function
  final Function onUpdate;
  //// Pointer to Delete Function
  final Function onDelete;
  //// Pointer to Decrease Function
  final Function onDecrease;

  const ItemCard(this.name, this.age,
      {super.key,
      required this.onUpdate,
      required this.onDelete,
      required this.onDecrease});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                // width: MediaQuery.of(context).size.width * 0.5,
                child: Text(name,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, fontSize: 16)),
              ),
              Text(
                "$age years old",
                style: GoogleFonts.poppins(),
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                height: 40,
                width: 60,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, padding: EdgeInsets.zero),
                    child: const Center(
                        child: Icon(
                      Icons.arrow_downward,
                      color: Colors.white,
                    )),
                    onPressed: () {
                      onDecrease();
                    }),
              ),
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                height: 40,
                width: 60,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.zero),
                    child: const Center(
                        child: Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                    )),
                    onPressed: () {
                      onUpdate();
                    }),
              ),
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                height: 40,
                width: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets
                        .zero, // Remove default padding to center the icon
                  ),
                  onPressed: () {
                    onDelete();
                  },
                  child: const Center(
                    // Use Center widget to explicitly center the icon
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
