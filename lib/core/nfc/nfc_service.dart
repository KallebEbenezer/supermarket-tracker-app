import 'package:nfc_manager/nfc_manager.dart';

class NfcService {
  Future<bool> isNfcAvailable() async {
    final availability = await NfcManager.instance.checkAvailability();
    return availability == NfcAvailability.enabled;
  }

  Future<String?> readTagUid() async {
    String? uid;
    try {
      await NfcManager.instance.startSession(
        pollingOptions: {NfcPollingOption.iso14443, NfcPollingOption.iso15693, NfcPollingOption.iso18092},
        onDiscovered: (NfcTag tag) async {
          final data = tag.data;
          if (data is Map) {
            final nfcaData = data['nfca'];
            if (nfcaData is Map) {
              final identifier = nfcaData['identifier'];
              if (identifier is List) {
                uid = identifier.map((e) => (e as int).toRadixString(16).padLeft(2, '0')).join(':');
              }
            }
          }
          await NfcManager.instance.stopSession();
        },
      );
    } on Exception {
      await NfcManager.instance.stopSession();
    }
    return uid;
  }
}
