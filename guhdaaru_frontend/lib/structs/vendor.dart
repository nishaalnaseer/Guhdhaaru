class Vendor{
  int id;
  String name;
  String email;
  String location;

  Vendor({
    required this.id,
    required this.name,
    required this.email,
    required this.location,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      location: json["location"]
    );
  }
}

class Listing{
  int id;
  int itemId;
  Vendor vendor;

  Listing({
    required this.id,
    required this.itemId,
    required this.vendor,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    // dynamic vendorRaw = json["vendor"];
    // Type type = vendorRaw.runtimeType;
    //
    // int? vendorID;
    // Vendor? vendor;
    // if(type == int) {
    //   vendorID = vendorRaw;
    //   vendor = null;
    // } {
    //   vendorID = null;
    //   vendor = Vendor.fromJson(vendorRaw);
    //   assert(vendor != null, 'vendor must not be null');
    // }

    return Listing(
        id: json["id"],
        itemId: json["item_id"],
        vendor: Vendor.fromJson(json["vendor"]),
    );
  }
}
