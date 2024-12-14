import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sprinchat_app/data/model/chatmodel.dart';

class Chatrepository {
  // 컬렉션(Chatroom)의 chatroomid 문서 읽기
  Future<List<Chatmodel>> get(String chatroomid) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference collectionRef = firestore.collection('Chatroom');

      QuerySnapshot snapshot = await collectionRef.get();
      List<QueryDocumentSnapshot> documentSnapshot = snapshot.docs;

      final docs = documentSnapshot.where((e) {
        return e.id.contains(chatroomid);
      });

      final list = docs.map((e) {
        final map = e.data() as Map<String, dynamic>;
        final newMap = {
          'chatroomid': e.id,
          ...map,
        };

        return Chatmodel.fromJson(newMap);
      }).toList();

      return list;
    } catch (e) {
      print('채팅 데이터 없음');
    }
    return [];
  }

  // 실시간 채팅 읽기 (스트림용)
  Stream<List<Chatmodel>> getStream(String chatroomid) {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference collectionRef = firestore.collection('Chatroom');

      final stream = collectionRef.snapshots();

      final newStream = stream.map((snapshot) {
        final docs = snapshot.docs.where((doc) {
          return doc.id.contains(chatroomid);
        });

        final list = docs.map((doc) {
          final map = doc.data() as Map<String, dynamic>;
          final newMap = {
            'chatroomid': chatroomid,
            ...map,
          };

          return Chatmodel.fromJson(newMap);
        }).toList();

        return list;
      });

      return newStream;
    } catch (e) {
      print('채팅 데이터 없음');
    }
    return Stream.empty();
  }

  // 컬렉션(Chatroom)의 chatroomid 문서 쓰기
  Future<void> insert(
      {required String chatroomid,
      required DateTime updatetime,
      required List<String> member,
      required List<Map<String, dynamic>> chats}) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference collectionRef = firestore.collection('Chatroom');

      final docRef = collectionRef.doc(chatroomid);

      Map<String, dynamic> map = {
        "chats": chats,
        "member": member,
        "updatetime": updatetime.toIso8601String(),
      };

      await docRef.set(map);
    } catch (e) {
      print('쓰기 실패');
    }
  }

  // 컬렉션(Chatroom)의 chatroomid 문서 업데이트
  // 사용자가 채팅을 쳤을때 주로 호출
  Future<void> update(String chatroomid, String userid, String chat) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference collectionRef = firestore.collection('Chatroom');

    final docRef = collectionRef.doc(chatroomid);

    Map<String, dynamic> map = {
      "updatetime": DateTime.now().toIso8601String(),
      "member": FieldValue.arrayUnion([userid]),
      "chats": FieldValue.arrayUnion([
        {
          "message": chat,
          "createdAt": DateTime.now().toIso8601String(),
          "userid": userid,
        }
      ])
    };

    await docRef.update(map);
  }

  // 컬렉션(Chatroom)의 chatroomid 문서 중 updatetime과 member속성만 업데이트
  // presenchatpage의 참여하기 버튼을 누르면 호출 (채팅방 참여)
  Future<void> updateMember(String chatroomid, String userid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference collectionRef = firestore.collection('Chatroom');

    final docRef = collectionRef.doc(chatroomid);

    Map<String, dynamic> map = {
      "member": FieldValue.arrayUnion([userid]),
    };

    await docRef.update(map);
  }

  // 컬렉션(Chatroom)의 chatroomid 문서 중 member리스트의 유저id 만 제거
    Future<void> deleteMember(String chatroomid, String userid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference collectionRef = firestore.collection('Chatroom');

    final docRef = collectionRef.doc(chatroomid);

    Map<String, dynamic> map = {
      "member": FieldValue.arrayRemove([userid]),
    };

    await docRef.update(map);
  }
}
