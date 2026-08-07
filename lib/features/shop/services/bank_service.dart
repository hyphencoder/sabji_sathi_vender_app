import 'package:supabase_flutter/supabase_flutter.dart';

import '../../auth/services/auth_service.dart';
import '../models/vendor_bank_model.dart';

class BankService {
  BankService._();

  static final SupabaseClient _client = Supabase.instance.client;

  static const String _table = 'vendor_bank_accounts';

  // ==========================================================
  // Create Bank Account
  // ==========================================================

  static Future<void> createBank(VendorBankModel bank) async {
    await _client.from(_table).insert(bank.toJson());
  }

  // ==========================================================
  // Get Current Vendor Bank
  // ==========================================================

  static Future<VendorBankModel?> getBank() async {
    final user = AuthService.currentUser;

    if (user == null) return null;

    final data = await _client
        .from(_table)
        .select()
        .eq('vendor_id', user.id)
        .eq('is_primary', true)
        .maybeSingle();

    if (data == null) return null;

    return VendorBankModel.fromJson(data);
  }

  // ==========================================================
  // Update Bank
  // ==========================================================

  static Future<void> updateBank(VendorBankModel bank) async {
    final user = AuthService.currentUser;

    if (user == null) return;

    await _client.from(_table).update(bank.toJson()).eq('vendor_id', user.id);
  }

  // ==========================================================
  // Delete Bank
  // ==========================================================

  static Future<void> deleteBank() async {
    final user = AuthService.currentUser;

    if (user == null) return;

    await _client.from(_table).delete().eq('vendor_id', user.id);
  }

  // ==========================================================
  // Check Bank Exists
  // ==========================================================

  static Future<bool> hasBank() async {
    final user = AuthService.currentUser;

    if (user == null) return false;

    final data = await _client
        .from(_table)
        .select('id')
        .eq('vendor_id', user.id)
        .maybeSingle();

    return data != null;
  }

  // ==========================================================
  // Save / Update Bank
  // ==========================================================

  static Future<void> saveBank(VendorBankModel bank) async {
    final exists = await hasBank();

    if (exists) {
      await updateBank(bank);
    } else {
      await createBank(bank);
    }
  }
}
