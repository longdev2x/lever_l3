class SearchRequest {
  //Từ khoá tìm kiếm
  final String? keyWord;
  //Số trang
  final int? pageIndex;
  //Phần tử mỗi trang
  final int? size;
  //Trạng thái người dùng
  final int? status;

  const SearchRequest(
    this.keyWord,
    this.pageIndex,
    this.size,
    this.status,
  );

  Map<String, dynamic> toJson() => {
    'keyWord' : keyWord,
    'pageIndex' : pageIndex,
    'size' : size,
    'status' : status,
  };
}
