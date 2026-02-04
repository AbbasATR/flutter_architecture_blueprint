// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get welcome => 'أهلاً وسهلاً';

  @override
  String get welcomeTo => 'أهلاً وسهلاً في';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get appTitle => 'كوانتم';

  @override
  String get pleaseEnter => 'يرجى إدخال';

  @override
  String get pleaseEnterAtLeast => 'يرجى إدخال ما لا يقل عن';

  @override
  String get characters => 'حروف';

  @override
  String get actions => 'اجراءات';

  @override
  String get choose => 'أختر';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get next => 'التالي';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get enterYourPhoneNumber => 'أدخل رقم هاتفك';

  @override
  String get searching => 'البحث';

  @override
  String get jet => 'JET';

  @override
  String get restaurants => 'المطاعم';

  @override
  String get shopping => 'التسوق';

  @override
  String get grocery => 'البقالة';

  @override
  String get flowers => 'الزهور';

  @override
  String get alakrakchyGroup => 'مجموعة الاطرقجي';

  @override
  String get saves => 'الخصومات';

  @override
  String get more => 'المزيد';

  @override
  String get newListings => 'القوائم الجديدة';

  @override
  String get home => 'الرئيسية';

  @override
  String get cart => 'السلة';

  @override
  String get orders => 'الطلبات';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get verification => 'التحقق';

  @override
  String get enterPinCode => 'أدخل رمز التحقق المرسل إلى الرقم';

  @override
  String get didntReceiveCode => 'لم تستلم الرمز؟';

  @override
  String get resend => 'إعادة الإرسال';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get close => 'إغلاق';

  @override
  String get localeCode => 'ar';

  @override
  String get countryCode => 'AE';

  @override
  String get imageUploadError => 'خطأ في تحميل الصورة. يرجى المحاولة مرة أخرى.';

  @override
  String get errorPrefix => 'خطأ:';

  @override
  String get noDataAvailable => 'لا توجد بيانات متاحة';

  @override
  String get whereToDeliver => 'أين تريد توصيل طلبك؟';

  @override
  String get addNewAddress => 'إضافة عنوان جديد';

  @override
  String get deliverToCurrentLocation => 'التوصيل إلى الموقع الحالي';

  @override
  String get searchHint => 'ابحث عن المنتجات أو المتاجر...';

  @override
  String get searchSuppliers => 'المتاجر';

  @override
  String get searchItems => 'المنتجات';

  @override
  String get searchStartSearching => 'ابدأ البحث عن المنتجات أو المتاجر';

  @override
  String get searchNoSuppliersFound => 'لم يتم العثور على متاجر';

  @override
  String get searchNoItemsFound => 'لم يتم العثور على منتجات';

  @override
  String searchNavigateTo(String name) {
    return 'الانتقال إلى $name';
  }

  @override
  String get searchMinDelivery => 'دقيقة';

  @override
  String get searchReviews => 'تقييم';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get noSuppliersAvailable => 'لا توجد متاجر متاحة';

  @override
  String get deliveryFee => 'رسوم التوصيل';

  @override
  String get minOrder => 'الحد الأدنى للطلب';

  @override
  String get viewCart => 'عرض السلة';

  @override
  String get chooseSize => 'اختر الحجم';

  @override
  String get specialInstructions => 'تعليمات خاصة';

  @override
  String get writeHere => 'اكتب هنا';

  @override
  String get addToCart => 'أضف إلى السلة';

  @override
  String get notAvailable => 'غير متوفر';

  @override
  String get calories => 'سعرة حرارية';

  @override
  String get cartEmpty => 'السلة فارغة';

  @override
  String get cartEmptyMessage => 'لا توجد منتجات';

  @override
  String get error => 'خطأ';

  @override
  String get checkout => 'إتمام الطلب';

  @override
  String get subtotal => 'المجموع الجزئي';

  @override
  String get total => 'الإجمالي';

  @override
  String get itemAddedToCart => 'تم إضافة المنتج إلى السلة';

  @override
  String get cartReplaced => 'تم استبدال السلة بمنتجات المتجر الجديد';

  @override
  String get checkoutComingSoon => 'إتمام الطلب قريباً';

  @override
  String get replaceCartTitle => 'استبدال السلة الحالية';

  @override
  String replaceCartMessage(String currentSupplier, String newSupplier) {
    return 'لديك منتجات في السلة من $currentSupplier. هل تريد حذف هذه المنتجات وإضافة من $newSupplier بدلاً من ذلك';
  }

  @override
  String get replaceCart => 'استبدال السلة';

  @override
  String get size => 'الحجم';

  @override
  String get activeOrders => 'الطلبات النشطة';

  @override
  String get pastOrders => 'الطلبات السابقة';

  @override
  String get noOrders => 'لا توجد طلبات بعد';

  @override
  String get viewOrder => 'عرض الطلب';

  @override
  String get orderDetails => 'تفاصيل الطلب';

  @override
  String get deliveredBy => 'تم التوصيل بواسطة:';

  @override
  String get reorder => 'إعادة الطلب';

  @override
  String get reorderComingSoon => 'ميزة إعادة الطلب قريباً';

  @override
  String get orderStatusOrdered => 'تم الطلب';

  @override
  String get orderStatusProcessing => 'قيد التجهيز';

  @override
  String get orderStatusReadyForPickup => 'جاهز للاستلام';

  @override
  String get orderStatusOnTheWay => 'في الطريق';

  @override
  String get orderStatusDelivered => 'تم التوصيل';

  @override
  String get orderStatusCanceled => 'ملغى';

  @override
  String get totalAmount => 'المبلغ الإجمالي';

  @override
  String get viewDetails => 'عرض التفاصيل';

  @override
  String get items => 'منتجات';

  @override
  String moreItems(int count) {
    return '+$count منتج إضافي';
  }

  @override
  String orderNumber(String number) {
    return 'الطلب رقم #$number';
  }

  @override
  String get deliveryAddress => 'عنوان التوصيل';

  @override
  String get discount => 'الخصم';

  @override
  String get tax => 'الضريبة';

  @override
  String get rate => 'تقييم';

  @override
  String get orderTracking => 'تتبع الطلب';

  @override
  String get orderPlaced => 'تم تقديم الطلب';

  @override
  String get confirmed => 'تم التأكيد';

  @override
  String get preparing => 'قيد التحضير';

  @override
  String get readyForPickup => 'جاهز للاستلام';

  @override
  String get onTheWay => 'في الطريق';

  @override
  String get accountSettings => 'إعدادات الحساب';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get contactSupport => 'اتصل بالدعم';

  @override
  String get language => 'اللغة';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get appearance => 'المظهر';

  @override
  String get system => 'النظام';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get favorites => 'المفضلة';

  @override
  String get addresses => 'العناوين';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get deliverTo => 'التوصيل إلى';

  @override
  String get deliveryTime => 'وقت التوصيل';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get placeOrder => 'تقديم الطلب';

  @override
  String get now => 'الآن';

  @override
  String get cashOnDelivery => 'الدفع عند التوصيل';

  @override
  String get work => 'العمل';

  @override
  String get addressSavedSuccessfully => 'تم حفظ العنوان بنجاح!';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get markAllRead => 'تحديد الكل كمقروء';

  @override
  String get errorLoadingNotifications => 'خطأ في تحميل الإشعارات';

  @override
  String get noNotifications => 'لا توجد إشعارات';

  @override
  String get noNotificationsMessage => 'لا توجد لديك أي إشعارات حتى الآن.\nسنقوم بإشعارك عندما يصل شيء جديد.';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(int minutes) {
    return 'منذ $minutes دقيقة';
  }

  @override
  String hoursAgo(int hours) {
    return 'منذ $hours ساعة';
  }

  @override
  String daysAgo(int days) {
    return 'منذ $days يوم';
  }

  @override
  String weeksAgo(int weeks) {
    return 'منذ $weeks أسبوع';
  }

  @override
  String get addressName => 'اسم العنوان';

  @override
  String get addressNameHint => 'مثل: المنزل، المكتب، إلخ';

  @override
  String get addressDetails => 'تفاصيل العنوان';

  @override
  String get enterFullAddress => 'أدخل عنوانك الكامل';

  @override
  String get selectIcon => 'اختر الأيقونة';

  @override
  String get other => 'أخرى';

  @override
  String get homeAddress => 'المنزل';

  @override
  String get pickLocation => 'اختر الموقع';

  @override
  String get selectedLocation => 'الموقع المحدد';

  @override
  String get confirmLocation => 'تأكيد الموقع';

  @override
  String get couldNotGetCurrentLocation => 'تعذر الحصول على الموقع الحالي. استخدام الموقع الافتراضي.';

  @override
  String failedToGetCurrentLocation(String error) {
    return 'فشل الحصول على الموقع الحالي: $error';
  }

  @override
  String get latitude => 'خط العرض';

  @override
  String get longitude => 'خط الطول';

  @override
  String get name => 'الاسم';

  @override
  String get pleaseEnterYourName => 'يرجى إدخال اسمك';

  @override
  String get dateOfBirth => 'تاريخ الميلاد';

  @override
  String get accountStatus => 'حالة الحساب';

  @override
  String get profileUpdatedSuccessfully => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get chooseFromGallery => 'اختر من المعرض';

  @override
  String get takePhoto => 'التقط صورة';

  @override
  String get removePhoto => 'إزالة الصورة';

  @override
  String get galleryPickerNotImplemented => 'منتقي المعرض لم يتم تنفيذه بعد';

  @override
  String get cameraNotImplemented => 'الكاميرا لم يتم تنفيذها بعد';
}
