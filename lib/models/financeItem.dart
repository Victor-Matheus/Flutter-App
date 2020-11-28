class FinanceItem {
  String title;
  String comment;
  double value;

  FinanceItem({this.title, this.value});

  FinanceItem.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    title = json['title'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment'] = this.comment;
    data['title'] = this.title;
    data['value'] = this.value;
    return data;
  }
}
