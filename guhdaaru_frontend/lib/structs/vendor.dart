class Vendor{
  int id;
  String name;
  String email;
  String location;
  String status;

  Vendor({
    required this.id,
    required this.name,
    required this.email,
    required this.location,
    required this.status,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      location: json["location"],
      status: json["status"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "location": location,
      "status": status,
    };
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

    return Listing(
        id: json["id"],
        itemId: json["item_id"],
        vendor: Vendor.fromJson(json["vendor"]),
    );
  }
}
