import 'package:codereader/extensions/barcode/type.dart';
import 'package:codereader/models/barcode_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_contacts/properties/address.dart' as contact_address;
import 'package:flutter_contacts/properties/email.dart' as contact_mail;
import 'package:flutter_contacts/properties/phone.dart' as contact_phone;
import 'package:mobile_scanner/mobile_scanner.dart';

List<BarcodeComponent> getContactComponents(ContactInfo? contactInfo) {
  return [
    BarcodeComponent(
        title: "タップして追加する",
        content: "タップして追加する",
        onTap: (context) async {
          if (contactInfo == null) return;

          var contact = Contact()
            ..name.first = contactInfo.name?.first ?? ""
            ..name.last = contactInfo.name?.last ?? "";
          //所属があるなら追加する
          if (contactInfo.title != null || contactInfo.organization != null) {
            contact.organizations = [
              Organization(
                company: contactInfo.organization ?? "",
                title: contactInfo.title ?? "",
              ),
            ];
          }
          //メールがあるなら追加する
          contact.emails = contactInfo.emails.map<contact_mail.Email>((e) {
            contact_mail.Email mail = contact_mail.Email(e.address ?? "");
            if (e.type != null) mail.label = e.label;
            return mail;
          }).toList();
          //電話があるなら追加する
          contact.phones = contactInfo.phones?.map<contact_phone.Phone>((e) {
                contact_phone.Phone phone = contact_phone.Phone(e.number ?? "");
                if (e.type != null) phone.label = e.label;
                return phone;
              }).toList() ??
              [];
          //住所を追加する
          contact.addresses =
              contactInfo.addresses.map<contact_address.Address>(
            (e) {
              contact_address.Address address =
                  contact_address.Address(e.addressLines.join(","));
              if (e.type != null) address.label = e.label;
              return address;
            },
          ).toList();
          //Webサイトを追加する
          contact.websites = contactInfo.urls?.map<Website>(
                (e) {
                  return Website(e);
                },
              ).toList() ??
              [];
          var title = "成功";
          var content = "連絡先の追加に成功しました。";
          //連絡先を追加する
          try {
            await contact.insert();
          } catch (e) {
            //エラーならメッセージを変更する。
            title = "失敗";
            if (e is PlatformException) {
              content = "アプリの権限などを確認してください。\n(${e.details})";
            } else {
              content = "連絡先の追加に失敗しました。";
            }
          }
          //エラーのダイアログを表示する。
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(title),
                content: Text(content),
                actions: [
                  TextButton(
                    child: const Text("閉じる"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            },
          );
        }),
    BarcodeComponent(
        title: "名前",
        content: contactInfo?.name?.formattedName,
        isImportant: true),
    BarcodeComponent(
      title: "所属",
      content: contactInfo?.organization,
      showTitleInResult: true,
    ),
    BarcodeComponent(
      title: "役職",
      content: contactInfo?.title,
      showTitleInResult: true,
    ),
    ...contactInfo?.phones?.map((e) => BarcodeComponent(
              title: "電話 ${e.toJapanese}",
              content: e.number,
              type: BarcodeComponentType.tel,
            )) ??
        [],
    ...contactInfo?.emails.map((e) => BarcodeComponent(
              title: "メール ${e.toJapanese}",
              content: e.address,
              type: BarcodeComponentType.email,
            )) ??
        [],
    ...contactInfo?.addresses.map((e) =>
            BarcodeComponent(title: "住所", content: e.addressLines.join(""))) ??
        [],
    ...contactInfo?.urls?.map((e) => BarcodeComponent(
              title: "URL",
              content: e,
              type: BarcodeComponentType.url,
            )) ??
        [],
  ];
}
