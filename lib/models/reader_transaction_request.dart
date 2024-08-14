class ReaderTransactionRequest {
  String? tlv;
  String? author;
  Map<String, dynamic>? metaData;
  int? accountType;
  String? terminalId;
  String? webhookURL;

  ReaderTransactionRequest({
    this.tlv,
    this.author,
    this.metaData,
    this.accountType,
    this.terminalId,
    this.webhookURL,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tlv'] = tlv;
    data['author'] = author;
    data['metaData'] = metaData;
    data['accountType'] = accountType;
    data['terminalId'] = terminalId;
    data['webhookURL'] = webhookURL;
    return data;
  }
}
