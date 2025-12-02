import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toysell_app/constant/theme.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String initialValue;
  final ValueChanged<String> onValueChanged;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.initialValue,
    required this.onValueChanged,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late String selectedValue;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  final ThemeHelper _themeHelper = Get.find<ThemeHelper>();

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  void _toggleDropdown(BuildContext context) {
    if (_overlayEntry == null) {
      _showDropdown(context);
    } else {
      _removeDropdown();
    }
  }

  void _showDropdown(BuildContext context) {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Tap outside to close
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeDropdown,
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            width: size.width,
            left: offset.dx,
            top: offset.dy,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(30.sp),
              color: _themeHelper.backgoundcolor,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.sp),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.items.map((item) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedValue = item;
                        });
                        widget.onValueChanged(item);
                        _removeDropdown();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 12.sp),
                        child: Text(
                          item,
                          style: TextStyle(fontSize: 12.sp, color: Colors.black),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: () => _toggleDropdown(context),
        child: Container(
          height: 40.sp,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.sp),
            border: Border.all(color: Colors.black),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedValue,
                style: TextStyle(fontSize: 10.sp, color: Colors.black),
              ),
              const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
