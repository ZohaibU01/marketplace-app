import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constant/constants.dart';
import '../../../constant/theme.dart';
import 'package:toysell_app/components/gradient_button.dart';

class ManageAddressScreen extends StatefulWidget {
  ManageAddressScreen({super.key});

  @override
  State<ManageAddressScreen> createState() => _ManageAddressScreenState();
}

class _ManageAddressScreenState extends State<ManageAddressScreen> {
  final RxList<Map<String, dynamic>> addresses = <Map<String, dynamic>>[].obs;

  // List of states and cities in Sweden
  final List<String> states = ["Stockholm", "Västra Götaland", "Skåne", "Uppsala", "Östergötland"];
  final Map<String, List<String>> cities = {
    "Stockholm": ["Stockholm", "Södertälje", "Huddinge"],
    "Västra Götaland": ["Gothenburg", "Borås", "Trollhättan"],
    "Skåne": ["Malmö", "Lund", "Helsingborg"],
    "Uppsala": ["Uppsala", "Enköping"],
    "Östergötland": ["Linköping", "Norrköping"],
  };

  @override
  Widget build(BuildContext context) {
    var themeHelper = Get.find<ThemeHelper>();

    return Scaffold(
      backgroundColor: themeHelper.colorwhite,
      appBar: AppBar(
        title: Text("Manage Address", style: TextStyle(color: themeHelper.textcolor)),
        backgroundColor: themeHelper.backgoundcolor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: themeHelper.textcolor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Constants.screenPadding),
        child: Column(
          children: [
            Obx(() => addresses.isEmpty
                ? Expanded(
              child: Center(
                child: Text("No addresses added yet.", style: TextStyle(color: themeHelper.textcolor)),
              ),
            )
                : Expanded(
              child: ListView.builder(
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final address = addresses[index];
                  // Create the formatted address string
                  final formattedAddress =
                      "${address["area"]}, ${address["city"]}, ${address["state"]}, ${address["pincode"]}, Sweden";
                  return GestureDetector(
                    onTap: () => Navigator.pop(context, formattedAddress),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10.sp),
                      padding: EdgeInsets.all(12.sp),
                      decoration: BoxDecoration(
                        border: Border.all(color: themeHelper.greyColor),
                        borderRadius: BorderRadius.circular(10.sp),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address["name"],
                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: themeHelper.textcolor),
                          ),
                          Text("State: ${address["state"]}", style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                          Text("City: ${address["city"]}", style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                          Text("Area: ${address["area"]}", style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                          Text("Pincode: ${address["pincode"]}", style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeHelper.colorPrimary,
        onPressed: () => _showAddAddressDialog(context),
        child: Icon(Icons.add, color: themeHelper.colorwhite),
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController areaController = TextEditingController();
    final TextEditingController pincodeController = TextEditingController();

    String? selectedState;
    String? selectedCity;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        final themeHelper = Get.find<ThemeHelper>();

        return StatefulBuilder(
          builder: (context,setState) {
            return SingleChildScrollView(
              child: Dialog(
                backgroundColor: themeHelper.backgoundcolor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Close Button
                      Row(
                        children: [
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: themeHelper.colorIcon.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Icon(Icons.close, size: 18, color: themeHelper.textcolor),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
              
                      // Title
                      Text(
                        "Add New Address",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: themeHelper.textcolor),
                      ),
              
                      SizedBox(height: 8),
              
                      // Divider
                      Divider(thickness: 1, color: themeHelper.colorIcon.withOpacity(0.3)),
              
                      SizedBox(height: 16),
              
                      // Address Name Input
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: "Address Name",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
              
                      SizedBox(height: 16),
              
                      // State Dropdown
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "Select State",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        items: states.map((state) {
                          return DropdownMenuItem(value: state, child: Text(state));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedState = value;
                            selectedCity = null; // Reset city when state changes
                          });
                        },
                        value: selectedState,
                      ),
              
                      SizedBox(height: 16),
              
                      // City Dropdown (Dependent on Selected State)
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "Select City",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        items: (selectedState != null ? cities[selectedState!] ?? <String>[] : <String>[]).map((city) {
                          return DropdownMenuItem(value: city, child: Text(city));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCity = value;
                          });
                        },
                        value: selectedCity,
                      ),
              
                      SizedBox(height: 16),
              
                      // Area Input
                      TextField(
                        controller: areaController,
                        decoration: InputDecoration(
                          labelText: "Area Name",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
              
                      SizedBox(height: 16),
              
                      // Pincode Input
                      TextField(
                        controller: pincodeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Pincode",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
              
                      SizedBox(height: 24),
              
                      // Add Address Button
                      GradientButton(
                        label: "Add Address",
                        onPressed: () {
                          if (nameController.text.isEmpty || selectedState == null || selectedCity == null || areaController.text.isEmpty || pincodeController.text.isEmpty) {
                            Get.snackbar("Error", "Please fill all fields");
                            return;
                          }
              
                          addresses.add({
                            "name": nameController.text.trim(),
                            "state": selectedState,
                            "city": selectedCity,
                            "area": areaController.text.trim(),
                            "pincode": pincodeController.text.trim(),
                          });
              
                          Navigator.pop(context);
                        },
                      ),
              
                      SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            );
          }
        );
      },
    );
  }
}
