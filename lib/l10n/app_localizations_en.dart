// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcome => 'Welcome';

  @override
  String get welcomeTo => 'Welcome to';

  @override
  String get login => 'Login';

  @override
  String get appTitle => 'jet_customer';

  @override
  String get pleaseEnter => 'Please enter';

  @override
  String get pleaseEnterAtLeast => 'Please enter at least';

  @override
  String get characters => 'characters';

  @override
  String get actions => 'Actions';

  @override
  String get choose => 'Choose';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get next => 'Next';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get enterYourPhoneNumber => 'Enter your phone number';

  @override
  String get searching => 'Searching';

  @override
  String get jet => 'JET';

  @override
  String get restaurants => 'Restaurants';

  @override
  String get shopping => 'Shopping';

  @override
  String get grocery => 'Grocery';

  @override
  String get flowers => 'Flowers';

  @override
  String get alakrakchyGroup => 'Alakrakchy Group';

  @override
  String get saves => 'Saves';

  @override
  String get more => 'More';

  @override
  String get newListings => 'New listings';

  @override
  String get home => 'Home';

  @override
  String get cart => 'Cart';

  @override
  String get orders => 'Orders';

  @override
  String get profile => 'Profile';

  @override
  String get verification => 'Verification';

  @override
  String get enterPinCode => 'Enter the pin code sent to the number';

  @override
  String get didntReceiveCode => 'Didn\'t receive code?';

  @override
  String get resend => 'Resend';

  @override
  String get seeAll => 'See All';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get confirmDelete => 'Confirm delete';

  @override
  String get close => 'Close';

  @override
  String get localeCode => 'en';

  @override
  String get countryCode => 'US';

  @override
  String get imageUploadError => 'Error uploading image. Please try again.';

  @override
  String get errorPrefix => 'Error:';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get whereToDeliver => 'Where should we deliver your order?';

  @override
  String get addNewAddress => 'Add a new address';

  @override
  String get deliverToCurrentLocation => 'Deliver to current location';

  @override
  String get searchHint => 'Search for items or suppliers...';

  @override
  String get searchSuppliers => 'Suppliers';

  @override
  String get searchItems => 'Items';

  @override
  String get searchStartSearching => 'Start searching for items or suppliers';

  @override
  String get searchNoSuppliersFound => 'No suppliers found';

  @override
  String get searchNoItemsFound => 'No items found';

  @override
  String searchNavigateTo(String name) {
    return 'Navigate to $name';
  }

  @override
  String get searchMinDelivery => 'min';

  @override
  String get searchReviews => 'reviews';

  @override
  String get retry => 'Retry';

  @override
  String get noSuppliersAvailable => 'No suppliers available';

  @override
  String get deliveryFee => 'Delivery Fee';

  @override
  String get minOrder => 'Min Order';

  @override
  String get viewCart => 'View Cart';

  @override
  String get chooseSize => 'Choose Size';

  @override
  String get specialInstructions => 'Special instructions';

  @override
  String get writeHere => 'Write here';

  @override
  String get addToCart => 'Add to cart';

  @override
  String get notAvailable => 'Not available';

  @override
  String get calories => 'calories';

  @override
  String get cartEmpty => 'Your cart is empty';

  @override
  String get cartEmptyMessage => 'Add items to get started';

  @override
  String get error => 'Error';

  @override
  String get checkout => 'Checkout';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get total => 'Total';

  @override
  String get itemAddedToCart => 'Item added to cart';

  @override
  String get cartReplaced => 'Cart replaced with new item';

  @override
  String get checkoutComingSoon => 'Checkout functionality coming soon';

  @override
  String get replaceCartTitle => 'Replace cart items?';

  @override
  String replaceCartMessage(String currentSupplier, String newSupplier) {
    return 'Your cart contains items from $currentSupplier. Do you want to empty your cart and add items from $newSupplier instead?';
  }

  @override
  String get replaceCart => 'Replace Cart';

  @override
  String get size => 'Size';

  @override
  String get activeOrders => 'Active Orders';

  @override
  String get pastOrders => 'Past Orders';

  @override
  String get noOrders => 'No orders yet';

  @override
  String get viewOrder => 'View order';

  @override
  String get orderDetails => 'Order details';

  @override
  String get deliveredBy => 'Delivered by:';

  @override
  String get reorder => 'Reorder';

  @override
  String get reorderComingSoon => 'Reorder functionality coming soon';

  @override
  String get orderStatusOrdered => 'Ordered';

  @override
  String get orderStatusProcessing => 'Processing';

  @override
  String get orderStatusReadyForPickup => 'Ready for Pickup';

  @override
  String get orderStatusOnTheWay => 'On the Way';

  @override
  String get orderStatusDelivered => 'Delivered';

  @override
  String get orderStatusCanceled => 'Canceled';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get viewDetails => 'View Details';

  @override
  String get items => 'items';

  @override
  String moreItems(int count) {
    return '+$count more items';
  }

  @override
  String orderNumber(String number) {
    return 'Order #$number';
  }

  @override
  String get deliveryAddress => 'Delivery Address';

  @override
  String get discount => 'Discount';

  @override
  String get tax => 'Tax';

  @override
  String get rate => 'Rate';

  @override
  String get orderTracking => 'Order Tracking';

  @override
  String get orderPlaced => 'Order Placed';

  @override
  String get confirmed => 'Confirmed';

  @override
  String get preparing => 'Preparing';

  @override
  String get readyForPickup => 'Ready for Pickup';

  @override
  String get onTheWay => 'On the Way';

  @override
  String get accountSettings => 'Account setting';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get contactSupport => 'Contact support';

  @override
  String get language => 'Language';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get appearance => 'Appearance';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get favorites => 'Favorites';

  @override
  String get addresses => 'Addresses';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get signOut => 'Sign out';

  @override
  String get deliverTo => 'Deliver to';

  @override
  String get deliveryTime => 'Delivery Time';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get placeOrder => 'Place Order';

  @override
  String get now => 'Now';

  @override
  String get cashOnDelivery => 'Cash on delivery';

  @override
  String get work => 'Work';

  @override
  String get addressSavedSuccessfully => 'Address saved successfully!';

  @override
  String get notifications => 'Notifications';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get errorLoadingNotifications => 'Error loading notifications';

  @override
  String get noNotifications => 'No Notifications';

  @override
  String get noNotificationsMessage => 'You don\'t have any notifications yet.\nWe\'ll notify you when something new arrives.';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int minutes) {
    return '${minutes}m ago';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String daysAgo(int days) {
    return '${days}d ago';
  }

  @override
  String weeksAgo(int weeks) {
    return '${weeks}w ago';
  }

  @override
  String get addressName => 'Address Name';

  @override
  String get addressNameHint => 'e.g., Home, Office, etc.';

  @override
  String get addressDetails => 'Address Details';

  @override
  String get enterFullAddress => 'Enter your full address';

  @override
  String get selectIcon => 'Select Icon';

  @override
  String get other => 'Other';

  @override
  String get homeAddress => 'Home';

  @override
  String get pickLocation => 'Pick Location';

  @override
  String get selectedLocation => 'Selected Location';

  @override
  String get confirmLocation => 'Confirm Location';

  @override
  String get couldNotGetCurrentLocation => 'Could not get current location. Using default location.';

  @override
  String failedToGetCurrentLocation(String error) {
    return 'Failed to get current location: $error';
  }

  @override
  String get latitude => 'Lat';

  @override
  String get longitude => 'Long';

  @override
  String get name => 'Name';

  @override
  String get pleaseEnterYourName => 'Please enter your name';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get accountStatus => 'Account Status';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get galleryPickerNotImplemented => 'Gallery picker not implemented yet';

  @override
  String get cameraNotImplemented => 'Camera not implemented yet';
}
