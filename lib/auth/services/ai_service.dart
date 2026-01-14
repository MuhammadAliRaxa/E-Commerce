import 'dart:convert';

import 'package:flutter_e_commerce_app/auth/services/firebaseServices.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SmartAIService {
  final _firebaseServices=Firebaseservices();
  final model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: 'AIzaSyA9-CAbe9CYmzLYJud9G6UYR6JSkiuwkIo',
  );

//   Future<String> chat(String userInput) async {
//     final response = await model.generateContent([
//       Content.text("""
// You are a Smart E-commerce AI Assistant inside a mobile shopping app.

// Your job:
// • Chat naturally with users.
// • Detect intent (search, order tracking, FAQs, filter, recommend).
// • Return structured JSON so the Flutter app can handle actions.

// -----------------------------
// RULES
// -----------------------------
// 1. If user is talking casually → normal natural response (NO JSON).
// 2. If user intent is e-commerce related:
//    - Identify intent
//    - Produce TWO outputs:
//        a) <assistant_response> ... </assistant_response>
//        b) <action_json> { ... } </action_json>
// 3. JSON MUST ALWAYS be valid.
// 4. JSON MUST NEVER be inside assistant_response.
// 5. JSON keys MUST always exist.

// -----------------------------
// OUTPUT FORMAT
// -----------------------------
// <assistant_response>
// Your natural reply here.
// </assistant_response>

// <action_json>
// {
//   "action": "search" | "order_status" | "filter" | "faq" | "recommend" | "unknown",
//   "query": "",
//   "category": "",
//   "brand": "",
//   "price_min": null,
//   "price_max": null,
//   "order_id": "",
//   "additional_filters": {}
// }
// </action_json>

// -----------------------------
// EXAMPLES
// -----------------------------

// Example 1:
// User: “Show me men shoes under 2000”

// <assistant_response>
// Sure! Here are some men's shoes under 2000 you might like.
// </assistant_response>

// <action_json>
// {
//   "action": "search",
//   "category": "shoes",
//   "brand": "",
//   "price_min": null,
//   "price_max": 2000,
//   "query": "men shoes under 2000",
//   "order_id": "",
//   "additional_filters": {
//     "gender": "men"
//   }
// }
// </action_json>

// Example 2:
// User: “Where is my order 1290?”

// <assistant_response>
// Let me check the status of your order 1290.
// </assistant_response>

// <action_json>
// {
//   "action": "order_status",
//   "order_id": "1290"
// }
// </action_json>

// Example 3:
// User: “Do you have red t-shirts?”

// <assistant_response>
// Yes! Here are some red t-shirts.
// </assistant_response>

// <action_json>
// {
//   "action": "search",
//   "category": "t-shirt",
//   "query": "red t-shirts",
//   "additional_filters": { "color": "red" }
// }
// </action_json>

// Example 4:
// User: “I need help with returns”

// <assistant_response>
// We offer 7-day return service. Do you want help creating a return request?
// </assistant_response>

// <action_json>
// {
//   "action": "faq",
//   "query": "return policy"
// }
// </action_json>

// Example 5:
// User: “Suggest something for me”

// <assistant_response>
// Sure! What category would you like suggestions from?
// </assistant_response>

// <action_json>
// {
//   "action": "recommend"
// }
// </action_json>

// -----------------------------
// BEHAVIOR RULES
// -----------------------------
// • Understand incomplete English: “cheap shoes”, “kid dress”, “red bag”.
// • If unsure, set "action": "unknown".
// • If unrelated to shopping → ONLY assistant_response (no JSON).

// Your goal:
// Make shopping smooth, intelligent, fast, and conversational.
// """),
//       Content.text(userInput)
//     ]);

//     final aiText = response.text?.toLowerCase() ?? '';
//     if(aiText.contains("track_order")){
       
//       final result = await _trackOrder(userInput);
//       return "$result";
//     }

    
//     if (aiText.contains("search")) {
      
//       final result = await _searchFirebase(userInput);
//       return "$result";
//     }

//     return response.text ?? "I'm here to help!";
//   }
  Future<String> _trackOrder(String query) async {
  final user = await _firebaseServices.getCurrentUser();
  if (user == null) return "Please log in to check your orders.";

  final snapshot = await FirebaseFirestore.instance
      .collection("order")
      .where("customerId",isEqualTo: user.id)
      .get();

  if (snapshot.docs.isEmpty) return "You have no orders yet.";
  print(snapshot.docs.single);

  for (final doc in snapshot.docs) {
    final data = doc.data();
    final List items = data['items'] ?? [];
    final hasProduct = items.length>0;
    if (hasProduct || query.toLowerCase().contains(data['id'].toString().toLowerCase())) {
      return """
Here’s your order update 📦
Order ID: ${data['saleId']}
Status: ${data["status"]}
""";
    }
  }

  return "I couldn’t find that order. Please tell me the product name or order ID.";
}


  Future<String> _searchFirebase(String query) async {
    final keyword = query.toLowerCase();
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .get();

    final results = snapshot.docs.where((doc) {
      final data = doc.data();
      final name = data['name']?.toString().toLowerCase() ?? '';
      final category = data['category']?.toString().toLowerCase() ?? '';
      return name.contains(keyword) || category.contains(keyword);
    }).toList();

    if (results.isEmpty) return "I couldn't find anything for '$keyword'. 😕";

    final items = results.take(3).map((d) {
      final p = d.data();
      return "${p['name']} — \Rs${p['price']}";
    }).join("\n");

    return "Here’s what I found 👇\n$items";
  }
String systemPrompt="""You are a Smart E-commerce AI Assistant inside a mobile shopping app.

Your job:
• Chat naturally with users.
• Detect intent (search, order tracking, FAQs, filter, recommend).
• Return structured JSON so the Flutter app can handle actions.

-----------------------------
RULES
-----------------------------
1. If user is talking casually → normal natural response (NO JSON).
2. If user intent is e-commerce related:
   - Identify intent
   - Produce outputs:
       a) <action_json> { ... } </action_json>
3. JSON MUST ALWAYS be valid.
4. JSON MUST NEVER be inside assistant_response.
5. JSON keys MUST always exist.

-----------------------------
OUTPUT FORMAT
-----------------------------

Your natural reply here.


<action_json>
{
  "action": "search" | "order_status" | "filter" | "faq" | "recommend" | "unknown",
  "query": "",
  "category": "",
  "brand": "",
  "price_min": null,
  "price_max": null,
  "order_id": "",
  "additional_filters": {}
}
</action_json>

-----------------------------
EXAMPLES
-----------------------------

Example 1:
User: “Show me men shoes under 2000”

Sure! Here are some men's shoes under 2000 you might like.

<action_json>
{
  "action": "search",
  "category": "shoes",
  "brand": "",
  "price_min": null,
  "price_max": 2000,
  "query": "men shoes under 2000",
  "order_id": "",
  "additional_filters": {
    "gender": "men"
  }
}
</action_json>

Example 2:
User: “Where is my order 1290?”

Let me check the status of your order 1290.

<action_json>
{
  "action": "order_status",
  "order_id": "1290"
}
</action_json>

Example 3:
User: “Do you have red t-shirts?”


Yes! Here are some red t-shirts.


<action_json>
{
  "action": "search",
  "category": "t-shirt",
  "query": "red t-shirts",
  "additional_filters": { "color": "red" }
}
</action_json>

Example 4:
User: “I need help with returns”

We offer 7-day return service. Do you want help creating a return request?


<action_json>
{
  "action": "faq",
  "query": "return policy"
}
</action_json>

Example 5:

User: “Suggest something for me”


Sure! What category would you like suggestions from?

-----------------------------
BEHAVIOR RULES
-----------------------------
• Understand incomplete English: “cheap shoes”, “kid dress”, “red bag”.
• If unsure, set "action": "unknown".
• If unrelated to shopping → ONLY assistant_response (no JSON).

Your goal:
Make shopping smooth, intelligent, fast, and conversational.
""";
Future<String> chat(String userInput) async {
  final response = await model.generateContent([
    Content.text(systemPrompt),
    Content.text(userInput)
  ]);

  final raw = response.text ?? "";
  
  // Extract JSON inside <action_json> ... </action_json>
  final jsonMatch = RegExp(r"<action_json>([\s\S]*?)</action_json>")
      .firstMatch(raw);

  if (jsonMatch == null) {
    // No JSON → normal chat
    return raw;
  }

  final jsonString = jsonMatch.group(1)!;

  Map<String, dynamic> action;
  try {
    action = jsonDecode(jsonString);
  } catch (_) {
    return "Sorry, I couldn't understand that.";
  }

  final actionType = action["action"] ?? "unknown";

  if (actionType == "order_status") {
    return await _trackOrder(action["order_id"] ?? userInput);
  }

  if (actionType == "search") {
    return await _searchFirebase(
      action["query"] ?? userInput
    );
  }
  if (actionType == "recommend") {
    return "";
  }

  return raw; // default
}

}
