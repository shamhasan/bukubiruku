import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ReceiptScannerService {
  final String apiKey = dotenv.env['GEMINI_API_KEY']!;
  Future<Map<String, dynamic>?> scanReceipt(File ImageFile) async {
    try {
      final model = GenerativeModel(apiKey: apiKey, model: 'gemini-2.5-flash');

      final prompt = TextPart(""" 
      You are a receipt scanning machine. Analyze the image provided.
        Extract the following information into a strictly valid JSON format:
        
        {
          "description": (string, merchant name or store name or shor activity description),
          "amount": (numeric double, total payment amount),
          "type": (string, either "income" or "expense"),
          "category": (string, guess the category, if the type is "Income" : 
              'gaji','bonus',
              'hadiah',
              'penjualan',
              'investasi',
              'lainnya'; 
            if the type is "Expense" : 
              'Makan & Minum',
              'Transportasi',
              'pendidikan',
              'belanja',
              'tagihan & data',
              'kos',
              'hiburan',
              'kesehatan',
              'lainnya',)
        }

        Rules:
        1. Return ONLY the JSON. No markdown formatting (```json), no intro text.
        2. If specific field is missing, fill with null.
        3. Convert currency to plain number (e.g. "Rp 50.000" -> 50000).
      """);

      final imageBytes = await ImageFile.readAsBytes();
      final imagePart = DataPart('image/jpeg', imageBytes);

      final response = await model.generateContent([
        Content.multi([prompt, imagePart]),
      ]);

      if (response.text != null) {
        String cleanJson = response.text!
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();

        return jsonDecode(cleanJson);
      }
      return null;
    } catch (e) {
      log("Error di Datasource Scanner: $e", name: "AiService error");
      throw Exception("Gagal konek ke AI $e");
    }
  }
}
