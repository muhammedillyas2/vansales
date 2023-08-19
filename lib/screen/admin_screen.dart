
import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:pdf/widgets.dart';
import 'package:restaurant_app/components/admin_firebase.dart';
import 'package:restaurant_app/components/firebase_con.dart' as fb;
import 'package:restaurant_app/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:csv/csv.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:restaurant_app/screen/pos_screen.dart';
import 'package:restaurant_app/components/database_con.dart' as dc;
RxBool productEdit=false.obs;
RxBool customerEdit=false.obs;
RxBool userDiscount=false.obs;
RxBool orgInvEdit=false.obs;
RxBool orgCompositeTax=false.obs;
RxBool orgCallCenter=false.obs;
RxBool orgMultiLineInvoice=false.obs;
RxBool orgQRCode=false.obs;
RxBool orgWaiterCheckout=false.obs;
RxBool userPriceEdit=false.obs;
String exportOrgName='';
String oldItemName='';
bool userEdit=false;
int addKot=0;
List<String> kotCategory=[];
List<String> kotPrinter=[];
int addUom = 0;
RxInt bomIndex=0.obs;
RxInt comboIndex=0.obs;
RxString importSelect='Product'.obs;
RxString exportSelect='TAX'.obs;
List<String> importSelectList=['Product','Customer','Vendor','Expense','Invoice'];
List<String> exportSelectList=['TAX','INVOICE','PRODUCT'];
List menu = [
  'Products',
  'UOM',
  'Category',
  'Tax',
  'User',
  'Sequence',
  'Organisation',
  'Customer',
  'Vendor',
  'Modifier',
  'Printer',
  'Expense Head',
  'Delivery Boy',
  'Import',
  'Table',
  'Export',
  'Payment Mode',
  'Routes'
];
List<String> mainPaymentList=['Cash','Card','Credit','UPI','EFT'];
TextEditingController mainPaymentController=TextEditingController();
TextEditingController customerVendorSearchController=TextEditingController();
List importData=[];
List<String> importCRoute=[];
List<String> importId=[],importItem=[],importCategory=[],importItemCode=[],importBarcodeType=[], importUom=[],importSp=[],importPp=[],importBarcode=[],importConversion=[],importTax=[],importDiscount=[],importProvision=[],importBom=[],importImage=[],importStockQty=[],importCostPrice=[];
List<String> importCName=[],importCAddress=[],importCFlatNo=[],importCBldNo=[], importCRoadNo=[],importCBlockNo=[],importCArea=[],importCLandmark=[], importCNote=[],importCMobileNo=[],importCVatNo=[],importCBalance=[],importCPriceList=[];
List<String> importVName=[],importVAddress=[],importVMobileNo=[],importVVatNo=[],importVBalance=[],importVPriceList=[];
List<String> importEHead=[],importETaxName=[],importETaxNo=[],importEBalance=[];
List<String> importIBalance=[],importICart=[],importICreatedBy=[],importICustomer=[],importIDate=[],importIDeliveryBoy=[],importIDType=[],importIDiscount=[],importIKotNo=[],importIOrderNo=[],importIPayment=[],importITotal=[],importITType=[],importIUser=[];
bool uploadDataEnable=false;
//table and floor
TextEditingController floorNameController=TextEditingController();
TextEditingController tableNameController=TextEditingController();
TextEditingController tablePaxController=TextEditingController();
//
//expense
TextEditingController expenseHeadController=TextEditingController();
TextEditingController expenseBalanceController=TextEditingController();
TextEditingController vatController=TextEditingController();
String expenseHead='',expenseVatNo='';

//
//printer
TextEditingController ipAddressEditController= TextEditingController();
TextEditingController printerNameEditController1 = TextEditingController();
TextEditingController bluetoothNameController = TextEditingController();
TextEditingController portNumberEditController1 = TextEditingController();
String ipAddress='', portNumber='', printerName='';
bool editPrinter=false;
PrinterBluetooth selectedPrinter;
Rx<List<PrinterBluetooth>> _devices = RxList<PrinterBluetooth>([]).obs;
List<bool> isSelectedPrinter= [true,false];
String printerType='Network';
PrinterBluetoothManager printerManager = PrinterBluetoothManager();
//printer
//vendor
String selectedVendorPrice='Price 1';
String vendorName='',vendorAddress='',vendorMobile='',vendorVat='',vendorBalance='';
TextEditingController vendorNameController=TextEditingController();
TextEditingController vendorAddressController=TextEditingController();
TextEditingController vendorMobileController=TextEditingController();
TextEditingController vendorVatController=TextEditingController();
TextEditingController vendorOpeningBalance=TextEditingController();
//vendor
//modifier
List<String> modifierType=['Topping','Flavour'];
String selectedModifierType='Topping';
String modifierDescription='';
TextEditingController modifierController=TextEditingController();
TextEditingController modifierPriceController=TextEditingController();
List<bool> selectedModifierCategory=[];
//
//customer
String selectedPrice='Price 1';
List<String> priceList=['Price 1','Price 2','Price 3'];
String customerName='',address='',mobile='',vat='',customerBalance='';
TextEditingController customerNameController=TextEditingController();
TextEditingController customerAddressController=TextEditingController();
TextEditingController customerMobileController=TextEditingController();
TextEditingController customerVatController=TextEditingController();
TextEditingController customerOpeningBalance=TextEditingController();
TextEditingController flatNoController=TextEditingController();
TextEditingController buildNoController=TextEditingController();
TextEditingController roadNoController=TextEditingController();
TextEditingController blockNoController=TextEditingController();
TextEditingController areaNoController=TextEditingController();
TextEditingController landmarkNoController=TextEditingController();
TextEditingController customerNoteController=TextEditingController();
//customer
//
//company
String selectedCloseHour='0';
List<String> closedHourList=['0','1','2','3','4','5','6'];
int addWarehouse=0;
int addBranch=0;
List<TextEditingController> warehouseController=[];
List<TextEditingController> branchController=[];
String organisationData='';
int decimals=0;
List<String> businessTypes=['Retail','WholeSale','Restaurant'];
List<String> screenList=['withImage','withoutImage'];
List<String> taxTypeList=['GST','VAT'];
String selectedBusiness='Restaurant';
String selectScreen='withImage';
String selectedTax='GST';
String orgName='',orgAddress='',orgVatNo='',orgMobileNo='',currency='',symbol='',orgDecimals='';
TextEditingController orgNameController=TextEditingController();
TextEditingController orgAddressController=TextEditingController();
TextEditingController orgVatNoController=TextEditingController();
TextEditingController orgTaxTitleController=TextEditingController(text: 'Tax Invoice');
TextEditingController orgMobileNoController=TextEditingController();
TextEditingController currencyController=TextEditingController();
TextEditingController symbolController=TextEditingController();
TextEditingController orgDecimalsController=TextEditingController();
// company
//
//user
List<String> terminalList=['Admin-POS','POS','Salesman','Owner','Kitchen','Call Center'];
List<String> userPrinterList=['Network','Bluetooth','T2MINI','V2PRO','PDF Thermal','PDF A4'];
String selectedTerminal='Admin-POS';
String selectedUserPrinter='Network';
RxString selectedUserPrinterName=''.obs;
String selectedWarehouse='';
String selectedBranch='';
double tillClose=0;
int tillCloseDate=0;
String userName='',password='',prefix='',userStartFrom='',userOrderFrom='';
TextEditingController userNameController=TextEditingController();
TextEditingController passwordController=TextEditingController();
TextEditingController prefixController=TextEditingController();
TextEditingController userStartFromController=TextEditingController();
TextEditingController userOrderFromController=TextEditingController();
//user
//
//delivery
TextEditingController deliveryNameController=TextEditingController();
TextEditingController deliveryPasswordController=TextEditingController();
TextEditingController deliveryMobileController=TextEditingController();
//
//tax
String taxName='',percentage='';
TextEditingController taxNameController=TextEditingController();
TextEditingController percentageController=TextEditingController();
//tax
//products
RxBool isCombo=false.obs;
RxInt addBom=0.obs;
RxInt addCombo=0.obs;
RxBool addImage = false.obs;
bool ite = false;
final validCharacters = RegExp(r'^[a-zA-Z0-9\@ ]+$');
String selectedCategory = '';
List<String> selectedUomList = [];
List<String> userNameList = [];
List<String> passwordList = [];
List<String> prefixList = [];
List<String> sp = [];
List<String> pp = [];
List<String> barcode = [];
List<String> conversion = [];
String itemName = '', itemCode = '', barcodeType = '', tax = '', discount = '',provisionType='Both';
String categoryName = '';
String uomName = '';
String routenameadd = '';
String discountEnable = 'No';
String invPrint='One';
String callCenterEnable='No';
enum selectedMode { Normal, Weighted }
enum selectedDiscount { Yes, No }
enum selectedInvoicePrint { One,Two }
enum callCenterSelected { Yes,No }
enum selectedProvision { Both,Salable, Purchasable }
selectedProvision _provision=selectedProvision.Both;
callCenterSelected _callCenter=callCenterSelected.No;
selectedMode _character = selectedMode.Normal;
selectedDiscount _orgDiscount = selectedDiscount.No;
selectedInvoicePrint _invoicePrint = selectedInvoicePrint.One;
TextEditingController uomNameController=TextEditingController();
TextEditingController routefield=TextEditingController();
TextEditingController itemNameController=TextEditingController();
TextEditingController itemCodeController=TextEditingController();
TextEditingController itemDiscountController=TextEditingController();
TextEditingController itemStockQtyController=TextEditingController(text: '0');
TextEditingController itemCostPriceController=TextEditingController(text: '0');
TextEditingController categoryNameController=TextEditingController();
List<TextEditingController> spController=[];
List<TextEditingController> ppController=[];
List<TextEditingController> barcodeController=[];
List<TextEditingController> conversionController=[];
Rx<List<TextEditingController>> bomItemController = RxList<TextEditingController>([]).obs;
Rx<List<TextEditingController>> bomQtyController = RxList<TextEditingController>([]).obs;
RxList bomUomList=[].obs;
Rx<List<TextEditingController>> comboCategoryController = RxList<TextEditingController>([]).obs;
Rx<List<String>> comboCategoryItemsController = RxList<String>([]).obs;
Rx<List<TextEditingController>> comboQtyController = RxList<TextEditingController>([]).obs;
RxList comboUomList=[].obs;
String docId='';
RxList searchResult=[].obs;
RxList searchResultComboItems=[].obs; //variable for adding combo items for selected category
RxList searchResultItemSearch=[].obs;
RxList searchResultCustomerVendor=[].obs;
RxList searchResultCategory=[].obs;
FocusNode nameNode=FocusNode();
TextEditingController nameEditController=TextEditingController();
//
//products
//
//sequence
List<String> transactionTypePrefix=[];
List<String> transactionTypeFrom=[];
String salesPrefix='',salesReturnPrefix='',purchasePrefix='',purchaseReturnPrefix='',receiptPrefix='',paymentPrefix='',expensePrefix='',stockPrefix='';
String salesFrom='',salesReturnFrom='',purchaseFrom='',purchaseReturnFrom='',receiptFrom='',paymentFrom='',expenseFrom='',stockFrom='';
List<String> type=['Sales Return','Purchase','Purchase Return','Receipt','Payment','Expense','Stock Transfer'];
List<TextEditingController> seqPrefixController=[];
List<TextEditingController> fromController=[];
//
//sequence

class AdminScreen extends StatefulWidget {
  static const String id='admin_screen';

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {

  void _startScanDevices() {


    printerManager.scanResults.listen((devices) async {
      _devices.value = RxList<PrinterBluetooth>([]);
      print('UI: Devices found ${devices.length}');
      for(int i=0;i<devices.length;i++){
        print('i $i');
        _devices.value.add(devices[i]);
      }
        // _devices.value = devices;
    });
    printerManager.startScan(Duration(seconds: 4));
    print('inside scan ${_devices.value}');
  }
  void _stopScanDevices() {
    printerManager.stopScan();
  }
  void searchOperation(String text) {
    searchResult.clear();
    if(text.length>0){
      for (int i = 0; i < allProducts.length; i++) {
        String data = allProducts[i];
        if (data.toLowerCase().contains(text.toLowerCase().replaceAll('/', '#'))) {
          searchResult.add(data);
        }
      }
    }
    else{
      searchResult.clear();
    }
  }
  //below function search items for particular category
  void searchCategoryItems(String text,String category) {
    List tempProducts=fb.categoryProducts(category);
    searchResultComboItems.clear();
    if(text.length>0){
      for (int i = 0; i < tempProducts.length; i++) {
        String data = tempProducts[i];
        if (data.toLowerCase().contains(text.toLowerCase().replaceAll('/', '#'))) {
          searchResultComboItems.add(data);
        }
      }
    }
    else{
      searchResultComboItems.clear();
    }
  }
  void searchCloud(String text) {
    searchResultItemSearch.clear();
    if(text.length>0){
      for (int i = 0; i < allProducts.length; i++) {
        String data = allProducts[i];
        if (data.toLowerCase().contains(text.toLowerCase().replaceAll('/', '#'))) {
          searchResultItemSearch.add(data);
        }
      }
    }
    else{
      searchResultItemSearch.clear();
    }
  }
  void searchCustomerVendor(String name,String type) {
    searchResultCustomerVendor.clear();
    List temp=[];
    if(type=='customer')
     temp=dc.customerList;
    else
      temp=dc.vendorList;
    if(name.length>0){
      for (int i = 0; i < temp.length; i++) {
        String data =temp[i];
        if (data.toLowerCase().contains(name.toLowerCase().replaceAll('/', '#'))) {
          searchResultCustomerVendor.add(data);
        }
      }
    }
    else{
      searchResultCustomerVendor.clear();
    }
  }
  void searchCategory(String text) {
    searchResultCategory.clear();
    if(text.length>0){
      for (int i = 0; i < allCategoryList.length; i++) {
        String data = allCategoryList[i];
        if (data.toLowerCase().contains(text.toLowerCase().replaceAll('/', '#'))) {
          searchResultCategory.add(data);
        }
      }
    }
    else{
      searchResultCategory.clear();
    }
  }
  Future uploadImage(Uint8List bytes,String imageName)async{
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("$imageName.jpg");
    UploadTask uploadTask = ref.putData(bytes, SettableMetadata(contentType: 'image/jpg'));
    uploadTask.then((res) async {
      var url= await res.ref.getDownloadURL();
        productImage.value = url.toString();
      print('productImage ${productImage.value}');
    });
  }
  String getBaseUom(String productName){
    for(int i=0;i<productFirstSplit.length;i++){
      List temp111=productFirstSplit[i].toString().split(':');
      if(temp111[0].toString().trim()==productName){
        List temp=productFirstSplit[i].split(':');
        List tempUom=temp[4].split('``');
        List tempUomSplit=tempUom[0].toString().split('*');
        return tempUomSplit[0];
      }
    }
    return '';
  }
  List<String> getUom(String productName){
    if(productName.isEmpty) {
      return [];
    }
    for(int i=0;i<productFirstSplit.length;i++){
      List temp=productFirstSplit[i].split(':');
      if(temp[0]==productName){
        List temp=productFirstSplit[i].split(':');
        List tempUom=temp[4].split('``');
        List<String> tempUomSplit=tempUom[0].toString().split('*');
        tempUomSplit.removeLast();
        return tempUomSplit;
      }
    }
    return [];
  }
  TextEditingController kotCategoryController=TextEditingController();
  int index1 = 7;
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double kWidth=MediaQuery.of(context).size.width/2.5;
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: SizedBox(
            width: MediaQuery.of(context).size.width / 6,
            height: MediaQuery.of(context).size.height / 6,
            child: Image.asset('images/logo_admin.png')),
        titleSpacing: 0.0,
        backgroundColor: kBackgroundColor,
        actions: [
          Padding(
            padding:  EdgeInsets.only(right:40),
            child: Center(
              child: Text('administration',style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontWeight: FontWeight.w500,
                  fontSize: MediaQuery.of(context).textScaleFactor*17,
                  letterSpacing: 2.0
              ),),
            ),
          ),
        ],
        automaticallyImplyLeading: true,

      ),
      body:  Container(
        child: Row(
          children: [
            Expanded(
                child: Container(
                  color: kBackgroundColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: menu.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    if(index==0){
                                      productEdit.value=false;
                                      await read('uom_data');
                                      await read('category_data');
                                      await read('tax_data');
                                      await read('product_data');
                                    }
                                    else if(index==4){
                                      userEdit=false;
                                      await read('warehouse');
                                      await read('branch_data');
                                      await read('printer_data');
                                    }
                                    else if(index==5){
                                      await getSequenceData();
                                    } else if(index==6){
                                      addWarehouse=0;
                                      warehouseController=[];
                                      addBranch=0;
                                      branchController=[];
                                      await read('warehouse');
                                      await read('branch_data');
                                      await getOrganisationData();
                                    }
                                    else if(index==9){
                                      await getOrganisationData();
                                      await read('category_data');
                                    }
                                    else if(index==7){
                                      await read('route_data');
                                    }
                                    else if(index==10){
                                      await read('category_data');
                                      await read('printer_data');
                                    }
                                    else if(index==11){
                                      await read('tax_data');
                                    }
                                    else if(index==14){
                                      await read('floor_data');
                                    }
                                    else if(index==17){
                                      // await read('route_data');
                                    }

                                    else if(index==13){
                                      importData=[];
                                      importId=[];
                                      importItem=[];
                                      importCategory=[];
                                      importItemCode=[];
                                      importBarcodeType=[];
                                      importUom=[];
                                      importTax=[];
                                      importDiscount=[];
                                    }
                                    setState(() {
                                      index1 = index;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 15.0,
                                        right: 15.0,
                                        top: 8.0,
                                        bottom: 8.0),
                                    color: kBoxColor,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Image.asset('images/icon${index + 1}.png'),
                                        Text(menu[index],
                                            style: TextStyle(
                                                fontFamily: 'CaviarDreams',
                                                color: kBoxTextColor,
                                                letterSpacing: 2.0)),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                )),
            Expanded(flex: 4, child: getWidget(index1)),
          ],
        ),
      ),
    ));
  }
  Widget getWidget(int index) {
    TextStyle kOrderTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: MediaQuery.of(context).textScaleFactor * 16,
    );
    TextStyle kOrderContentsTextStyle = TextStyle(
      fontSize: MediaQuery.of(context).textScaleFactor * 15,
    );
    if (index == 0) {
        addImage.value=false;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  padding: const EdgeInsets.all(50.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product Details',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: MediaQuery.of(context).textScaleFactor * 40,
                          color: kBackgroundColor,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 30.0,
                        color: Colors.white,
                        child: TextField(
                          inputFormatters: [
                            // only accept letters from a to z
                            FilteringTextInputFormatter(RegExp('[#]'), allow: false)
                          ],
                          controller: itemNameController,
                          decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.black38, width: 1.0)),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black38, width: 1.0),
                              ),
                              labelText: 'Item Name',
                              labelStyle: TextStyle(
                                color: Colors.black,
                              )),
                          onChanged: (value) {
                            itemName = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 30.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black38,
                              style: BorderStyle.solid,
                              width: 0.80),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            hint: Text('  Category List'),
                            value: selectedCategory,
                            items: allCategoryList.map((value) {
                              return DropdownMenuItem(value: value, child: Text(value));
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedCategory = newValue.toString();
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 30.0,
                        color: Colors.white,
                        child: TextField(
                          controller: itemCodeController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black38, width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38, width: 1.0),
                            ),
                            labelText: 'HSN Code',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          onChanged: (value) {
                            itemCode = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Obx(()=>Visibility(
                            visible: addImage.value,
                            replacement: Container(
                              child: MaterialButton(
                                  onPressed: () async {
                                    if(itemNameController.text.isEmpty){
                                      showDialog(context:context,
                                          builder: (BuildContext context){
                                            return AlertDialog(
                                              title: Text('Enter Item Name '),
                                            );
                                          }
                                      );
                                    }
                                    else{
                                      final picker = ImagePicker();
                                      final pickedFile = await picker.pickImage(
                                          source: ImageSource.gallery);
                                      Uint8List bytes = await pickedFile.readAsBytes();
                                      await  uploadImage(bytes,itemNameController.text);
                                      addImage.value = true;
                                    }
                                  },
                                  child: productImage.value.isNotEmpty?Text('Edit Image'):Text('Add Image')),
                            ),
                            child: Text(
                              'Image Uploaded',
                            ),
                          )),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.add_a_photo,
                            size: 50.0,
                          ),
                          productImage.value.isNotEmpty?
                         Obx(()=> Container(
                           height:MediaQuery.of(context).size.height*0.09,
                           width: MediaQuery.of(context).size.width*0.09,
                           decoration: BoxDecoration(
                               image: DecorationImage(
                                 // fit: BoxFit.fitWidth,
                                 image:NetworkImage(productImage.value),
                               )
                           ),
                         ))
                              :Text(''),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Barcode Type',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).textScaleFactor * 20,
                        ),
                      ),
                      RadioListTile(
                          activeColor: kBackgroundColor,
                          title: Text(
                            'Normal',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor * 20,
                            ),
                          ),
                          value: selectedMode.Normal,
                          groupValue: _character,
                          onChanged: (value) {
                            setState(() {
                              _character = value as selectedMode;
                              barcodeType = 'Normal';
                            });
                          }),
                      RadioListTile(
                          activeColor: kBackgroundColor,
                          title: Text(
                            'Weighted',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor * 20,
                            ),
                          ),
                          value: selectedMode.Weighted,
                          groupValue: _character,
                          onChanged: (value) {
                            setState(() {
                              _character = value as selectedMode;
                              barcodeType = 'Weighted';
                            });
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Provision Type',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).textScaleFactor * 20,
                        ),
                      ),
                      RadioListTile(
                          activeColor: kBackgroundColor,
                          title: Text(
                            'Both',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor * 20,
                            ),
                          ),
                          value: selectedProvision.Both,
                          groupValue: _provision,
                          onChanged: (value) {
                            setState(() {
                              _provision = value as selectedProvision;
                              provisionType = 'Both';
                            });
                          }),
                      RadioListTile(
                          activeColor: kBackgroundColor,
                          title: Text(
                            'Salable',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor * 20,
                            ),
                          ),
                          value: selectedProvision.Salable,
                          groupValue: _provision,
                          onChanged: (value) {
                            setState(() {
                              _provision = value as selectedProvision;
                              provisionType = 'Salable';
                            });
                          }),
                      RadioListTile(
                          activeColor: kBackgroundColor,
                          title: Text(
                            'Purchasable',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor * 20,
                            ),
                          ),
                          value: selectedProvision.Purchasable,
                          groupValue: _provision,
                          onChanged: (value) {
                            setState(() {
                              _provision = value as selectedProvision;
                              provisionType = 'Purchasable';
                            });
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton(
                                onPressed: () {
                                  print(uomList);
                                  if (addUom < uomList.length) {
                                    setState(() {
                                      print('uomList $uomList');
                                      addUom++;
                                      selectedUomList.add(uomList[0]);
                                      spController.add(TextEditingController(text: ''));
                                      ppController.add(TextEditingController(text: ''));
                                      barcodeController.add(TextEditingController(text: ''));
                                      conversionController.add(TextEditingController(text: '1'));
                                      sp.add('0');
                                      pp.add('0');
                                      barcode.add('0');
                                      conversion.add('1');
                                      print(selectedUomList);
                                    });
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  color: kBackgroundColor,
                                  child: Text(
                                    'ADD UOM',
                                    style: TextStyle(
                                      letterSpacing: 2.0,
                                      fontSize:
                                      MediaQuery.of(context).textScaleFactor * 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: DataTable(
                                dataRowHeight:80,
                                columns: [
                                  DataColumn(
                                      label: Text(
                                        'UOM',
                                        style: TextStyle(
                                          fontSize:
                                          MediaQuery.of(context).textScaleFactor * 20,
                                        ),
                                      )),
                                  DataColumn(
                                      label: Text(
                                        'S.P',
                                        style: TextStyle(
                                          fontSize:
                                          MediaQuery.of(context).textScaleFactor * 20,
                                        ),
                                      )),
                                  DataColumn(
                                      label: Text(
                                        'P.P',
                                        style: TextStyle(
                                          fontSize:
                                          MediaQuery.of(context).textScaleFactor * 20,
                                        ),
                                      )),
                                  DataColumn(
                                      label: Text(
                                        'Barcode',
                                        style: TextStyle(
                                          fontSize:
                                          MediaQuery.of(context).textScaleFactor * 20,
                                        ),
                                      )),
                                  DataColumn(
                                      label: Text(
                                        'Conversion',
                                        style: TextStyle(
                                          fontSize:
                                          MediaQuery.of(context).textScaleFactor * 20,
                                        ),
                                      )),
                                  DataColumn(
                                      label: Text(
                                        '',
                                        style: TextStyle(
                                          fontSize:
                                          MediaQuery.of(context).textScaleFactor * 20,
                                        ),
                                      )),
                                ],
                                rows: List.generate(
                                  addUom,
                                      (index) {
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          DropdownButton(
                                            hint: Text(
                                              'Select UOM',
                                              style: TextStyle(
                                                fontSize:
                                                MediaQuery.of(context).textScaleFactor *
                                                    20,
                                              ),
                                            ),
                                            value: selectedUomList[index],
                                            // Not necessary for Option 1
                                            items: uomList.map((String val) {
                                              return DropdownMenuItem(
                                                child: new Text(
                                                  val.toString(),
                                                  style: TextStyle(
                                                    fontSize: MediaQuery.of(context)
                                                        .textScaleFactor *
                                                        20,
                                                  ),
                                                ),
                                                value: val,
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedUomList[index] =
                                                    newValue.toString();
                                              });

                                              print(selectedUomList);
                                            },
                                          ),
                                        ),
                                        DataCell(Container(
                                          width: MediaQuery.of(context).size.width / 8,
                                          child: TextField(
                                            controller: spController[index],
                                            style: TextStyle(
                                              fontSize:
                                              MediaQuery.of(context).textScaleFactor *
                                                  20,
                                            ),
                                            onChanged: (value) {
                                              sp.insert(index, value);
                                            },
                                            keyboardType: TextInputType.number,
                                          ),
                                        )),
                                        DataCell(Container(
                                            width: MediaQuery.of(context).size.width / 8,
                                            child: TextField(
                                              controller: ppController[index],
                                              style: TextStyle(
                                                fontSize:
                                                MediaQuery.of(context).textScaleFactor *
                                                    20,
                                              ),
                                              onChanged: (value) {
                                                pp.insert(index, value);
                                              },
                                              keyboardType: TextInputType.number,
                                            ))),
                                        DataCell(Container(
                                            width: MediaQuery.of(context).size.width / 8,
                                            child: TextField(
                                              controller:barcodeController[index],
                                              style: TextStyle(
                                                fontSize:
                                                MediaQuery.of(context).textScaleFactor *
                                                    20,
                                              ),
                                              onChanged: (value) {
                                                barcode.insert(index, value);
                                              },
                                              keyboardType: TextInputType.number,
                                            ))),
                                        DataCell(Container(
                                            width: MediaQuery.of(context).size.width / 8,
                                            child: TextField(
                                              controller:conversionController[index],
                                              style: TextStyle(
                                                fontSize:
                                                MediaQuery.of(context).textScaleFactor *
                                                    20,
                                              ),
                                              onChanged: (value) {
                                                conversion.insert(index, value);
                                              },
                                              keyboardType: TextInputType.number,
                                            ))),
                                        DataCell(GestureDetector(
                                          child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                print(uomList);
                                                addUom--;
                                                selectedUomList.removeAt(index);
                                                sp.removeAt(index);
                                                pp.removeAt(index);
                                                barcode.removeAt(index);
                                                conversion.removeAt(index);
                                                print(selectedUomList);
                                              });
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ))
                                      ],
                                    );
                                      },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton(
                                onPressed: () {
                                  addBom++;
                                  bomItemController.value.add(TextEditingController(text: ''));
                                  bomUomList.add('');

                                  bomQtyController.value.add(TextEditingController(text: ''));
                                  print('addBom $addBom');
                                  print('bomItemController ${bomItemController.value}');
                                  print('bomUomList $bomUomList');
                                  print('bomQtyController ${bomQtyController.value}');
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  color: kBackgroundColor,
                                  child: Text(
                                    'ADD BOM',
                                    style: TextStyle(
                                      letterSpacing: 2.0,
                                      fontSize:
                                      MediaQuery.of(context).textScaleFactor * 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child:Obx(()=> DataTable(
                                dataRowHeight:80,
                                columns: [
                                  DataColumn(label: Text('Item', style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 20,),)),
                                  DataColumn(label: Text('Uom', style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 20,),)),
                                  DataColumn(label: Text('Qty', style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 20,),)),
                                  DataColumn(label: Text('', style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 20,),)),],
                                rows: List.generate(
                                  addBom.value,
                                      (index){
                                    bomIndex.value=index;
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          TextField(
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context).textScaleFactor*14,
                                            ),
                                            controller: bomItemController.value[index],
                                            decoration: new InputDecoration(
                                                border: OutlineInputBorder(),
                                                disabledBorder: OutlineInputBorder(
                                                ),
                                                enabledBorder: OutlineInputBorder(),
                                                hintText: 'search for items'
                                            ),
                                            onChanged: searchOperation,
                                          ),
                                        ),
                                        DataCell( Obx(()=>DropdownButton(
                                          value: bomUomList[index].toString().trim(),// Not necessary for Option 1
                                          items: getUom(bomItemController.value[index].text).map((String val) {
                                            return DropdownMenuItem(
                                              child: Text(val.toString().trim(),style: TextStyle(
                                                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                  color: Colors.black
                                              ),),
                                              value: val.trim(),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            print(newValue);
                                            bomUomList[index]=newValue.toString();
                                          },
                                        )),),
                                        DataCell(TextField(
                                          controller: bomQtyController.value[index],
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),
                                          ],
                                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                                          decoration:  const InputDecoration(
                                            hintText: 'Qty',
                                            border: OutlineInputBorder(),
                                            disabledBorder: OutlineInputBorder(
                                            ),
                                            enabledBorder: OutlineInputBorder(),
                                          ),
                                        )),
                                        DataCell(GestureDetector(
                                          child: IconButton(
                                            onPressed: () {
                                              addBom--;
                                              bomQtyController.value.removeAt(index);
                                              bomItemController.value.removeAt(index);
                                              bomUomList.removeAt(index);
                                              searchResult.value=[];
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ))
                                      ],
                                    );
                                      },
                                ),
                              ),),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width/3,
                          color: kItemContainer,
                          child:  Obx(()=> ListView.builder(
                            shrinkWrap: true,
                            itemCount: searchResult.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: (){
                                  print('insideeeeeeeeeeee iff search ${ bomItemController.value[bomIndex.value]}');
                                  bomItemController.value[bomIndex.value].text=searchResult[index];
                                  bomUomList[bomIndex.value]=getBaseUom(searchResult[index]) ;
                                  searchResult.value=[];
                                  print('base uomm $searchResult');

                                },
                                child: new ListTile(
                                  title: new Text(searchResult[index].toString()),
                                ),
                              );
                            },
                          ))
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(children: [
                        Text('Combo ',style: TextStyle(
                            fontWeight: FontWeight.bold
                          //  fontSize: MediaQuery.of(context).textScaleFactor * 20,
                        ),),
                        Obx(()=>  Checkbox(
                          value: isCombo.value,
                          onChanged: (bool value){
                            isCombo.value = value;
                          },
                        ),),
                      ],),
                      Obx(()=>  Visibility(
                        visible:isCombo.value,
                        child:  Container(
                            decoration: BoxDecoration(
                                border:Border.all(width: 2.0),
                            ),
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    addCombo++;
                                    comboCategoryController.value.add(TextEditingController(text: ''));
                                    comboUomList.add(uomList[0]);
                                    comboQtyController.value.add(TextEditingController(text: ''));
                                    comboCategoryItemsController.value.add('');
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10.0),
                                    color: kBackgroundColor,
                                    child: Text(
                                      'Add Combo Categories',
                                      style: TextStyle(
                                        letterSpacing: 2.0,
                                        fontSize:
                                        MediaQuery.of(context).textScaleFactor * 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )),
                              FittedBox(
                                fit: BoxFit.fitWidth,
                                child:Obx(()=> DataTable(
                                  dataRowHeight:80,
                                  columns: [
                                    DataColumn(label: Text('Category', style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 20,),)),
                                    DataColumn(label: Text('Items', style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 20,),)),
                                    DataColumn(label: Text('Uom', style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 20,),)),
                                    DataColumn(label: Text('Qty', style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 20,),)),
                                    DataColumn(label: Text('', style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 20,),)),],
                                  rows: List.generate(
                                    addCombo.value,
                                        (index){
                                          comboIndex.value=index;
                                      return DataRow(
                                        cells: [
                                          DataCell(
                                            TextField(
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context).textScaleFactor*14,
                                              ),
                                              controller: comboCategoryController.value[index],
                                              decoration: new InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  disabledBorder: OutlineInputBorder(
                                                  ),
                                                  enabledBorder: OutlineInputBorder(),
                                                  hintText: 'search for category'
                                              ),
                                              onChanged: searchCategory,
                                            ),
                                          ),
                                          DataCell(
                                            TextButton(
                                              child:Container(
                                                  padding: EdgeInsets.all(6.0),
                                                  color:kBackgroundColor,
                                                  child: Text('Add',style:TextStyle(color:Colors.white))),
                                              onPressed:(){
                                                if(allCategoryList.contains(comboCategoryController.value[index].text)){
                                                  RxList tempItemChip=[].obs;
                                                  TextEditingController dSearchField=TextEditingController();
                                                  String tempFinalVal='';
                                                  RxBool selectAllCheck=false.obs;
                                                  if(comboCategoryItemsController.value[index].length>0){
                                                    tempItemChip.value=comboCategoryItemsController.value[index].split(';');
                                                  }
                                                  showDialog(
                                                    context:
                                                    context,
                                                    builder: (ctx) =>
                                                        Center(
                                                          child: SizedBox(
                                                            width: MediaQuery.of(context).size.width/1.5,
                                                            height: MediaQuery.of(context).size.height/1.5,
                                                            child: Dialog(
                                                                backgroundColor: Colors.white,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(12.0)),
                                                                child:Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Align(
                                                                        // These values are based on trial & error method
                                                                        alignment: Alignment.topRight,
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(8.0),
                                                                          child: InkWell(
                                                                            onTap: () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child: Container(
                                                                              decoration: BoxDecoration(
                                                                                color:kBackgroundColor,
                                                                                borderRadius: BorderRadius.circular(12),
                                                                              ),
                                                                              child: Icon(
                                                                                Icons.close,
                                                                                size: 30,
                                                                                color: kFont1Color,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Align(
                                                                        // These values are based on trial & error method
                                                                          alignment: Alignment.center,
                                                                          child:Text('Add Combo Items',style:TextStyle(fontSize:20, fontWeight:FontWeight.bold,))
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width: MediaQuery.of(context).size.width/4,
                                                                            child: TextField(
                                                                              style: TextStyle(
                                                                                fontSize: MediaQuery.of(context).textScaleFactor*14,
                                                                              ),
                                                                              controller: dSearchField,
                                                                              decoration: new InputDecoration(
                                                                                  border: OutlineInputBorder(),
                                                                                  disabledBorder: OutlineInputBorder(
                                                                                  ),
                                                                                  enabledBorder: OutlineInputBorder(),
                                                                                  hintText: 'search for items'
                                                                              ),
                                                                              onChanged: (val){
                                                                                searchCategoryItems(val,comboCategoryController.value[index].text);
                                                                              },
                                                                            ),
                                                                          ),
                                                                          SizedBox(width:20),
                                                                          Row(children: [
                                                                            Text('Select All ',style: TextStyle(
                                                                                fontWeight: FontWeight.bold
                                                                              //  fontSize: MediaQuery.of(context).textScaleFactor * 20,
                                                                            ),),
                                                                            Obx(()=>  Checkbox(
                                                                              value: selectAllCheck.value,
                                                                              onChanged: (bool value){
                                                                                selectAllCheck.value = value;
                                                                                tempItemChip.value=[];
                                                                                if(value==true){
                                                                                 List tempProducts=fb.categoryProducts(comboCategoryController.value[index].text);
                                                                                 for(int i=0;i<tempProducts.length;i++)
                                                                                 tempItemChip.add(tempProducts[i]);
                                                                               }
                                                                              },
                                                                            ),),
                                                                          ],),
                                                                        ],
                                                                      ),
                                                                      SizedBox(height:10),
                                                                      Stack(
                                                                        children: [
                                                                          Container(
                                                                            height:200,
                                                                            width: MediaQuery.of(context).size.width/2,
                                                                            decoration: BoxDecoration(
                                                                              border:Border.all(width: 2.0),
                                                                            ),
                                                                              padding: const EdgeInsets.all(8.0),
                                                                            // child:Obx(()=>Wrap(
                                                                            //   direction: Axis.vertical,
                                                                            //   spacing: 10.0,
                                                                            //   runSpacing: 20.0,
                                                                            //   children:tempItemChip.map((item) =>   Chip(
                                                                            //     labelPadding: EdgeInsets.all(2.0),
                                                                            //     // avatar: CircleAvatar(child: Text(item.substring(0,2))),
                                                                            //     label: Text(
                                                                            //       item,
                                                                            //       style: TextStyle(
                                                                            //         color: Colors.black,
                                                                            //       ),
                                                                            //     ),
                                                                            //     onDeleted: (){
                                                                            //       int pos=tempItemChip.indexOf(item);
                                                                            //       tempItemChip.removeAt(pos);
                                                                            //     },
                                                                            //     backgroundColor: Colors.white,
                                                                            //     elevation: 6.0,
                                                                            //     shadowColor: Colors.black,
                                                                            //     padding: EdgeInsets.all(8.0),
                                                                            //   )).toList().cast<Widget>(),
                                                                            // ))
                                                                            child: Obx(()=>GridView.builder(
                                                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                                crossAxisCount: 3,
                                                                                childAspectRatio:MediaQuery.of(context).size.width /
                                                                                    (MediaQuery.of(context).size.height/2 ),
                                                                              ),
                                                                              scrollDirection: Axis.vertical,
                                                                              shrinkWrap: true,
                                                                              itemCount: tempItemChip.length,
                                                                              itemBuilder: (context,index){
                                                                                return  Chip(
                                                                                  labelPadding: EdgeInsets.all(2.0),
                                                                                  // avatar: CircleAvatar(child: Text(item.substring(0,2))),
                                                                                  label: Text(
                                                                                    tempItemChip[index],
                                                                                    style: TextStyle(
                                                                                      color: Colors.black,
                                                                                    ),
                                                                                  ),
                                                                                  onDeleted: (){
                                                                                    int pos=tempItemChip.indexOf(tempItemChip[index]);
                                                                                    tempItemChip.removeAt(pos);
                                                                                  },
                                                                                  backgroundColor: Colors.white,
                                                                                  elevation: 6.0,
                                                                                  shadowColor: Colors.black,
                                                                                  padding: EdgeInsets.all(8.0),
                                                                                );
                                                                              },
                                                                            )),
                                                                          ),
                                                                          Obx(() =>  Container(
                                                                              width: MediaQuery.of(context).size.width/4,
                                                                              decoration: BoxDecoration(
                                                                                  color: kItemContainer,
                                                                                  border: Border.all(color: kBackgroundColor)
                                                                              ),
                                                                              child: ListView.builder(
                                                                                shrinkWrap: true,
                                                                                itemCount: searchResultComboItems.length,
                                                                                itemBuilder: (BuildContext context, int index) {
                                                                                  return GestureDetector(
                                                                                    onTap: (){
                                                                                      if(tempItemChip.contains(searchResultComboItems[index])){
                                                                                        showDialog(
                                                                                            context: context,
                                                                                            builder: (context) => AlertDialog(
                                                                                              title: Text("Error"),
                                                                                              content: Text("Already added"),
                                                                                              actions: <Widget>[
                                                                                                // usually buttons at the bottom of the dialog
                                                                                                new TextButton(
                                                                                                  child: new Text("Close"),
                                                                                                  onPressed: () {
                                                                                                    Navigator.of(context).pop();
                                                                                                  },
                                                                                                ),
                                                                                              ],
                                                                                            )
                                                                                        );
                                                                                      }
                                                                                      else{
                                                                                        tempItemChip.add(searchResultComboItems[index]);
                                                                                        searchResultComboItems.clear();
                                                                                        dSearchField.clear();
                                                                                      }
                                                                                    },
                                                                                    child: new ListTile(
                                                                                      title: new Text(searchResultComboItems[index].toString().replaceAll('#', '/')),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              )
                                                                          ),),
                                                                        ],
                                                                      ),
                                                                      Align(
                                                                        // These values are based on trial & error method
                                                                        alignment: Alignment.center,
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(8.0),
                                                                          child: ElevatedButton(
                                                                            style: ButtonStyle(
                                                                              side: MaterialStateProperty.all(BorderSide(width: 2.0, color: kFont3Color,)),
                                                                              elevation: MaterialStateProperty.all(3.0),
                                                                              backgroundColor: MaterialStateProperty.all(kGreenColor),
                                                                            ),
                                                                            onPressed: () {
                                                                              if(tempItemChip.length>0){
                                                                                for(int i=0;i<tempItemChip.length;i++){
                                                                                  tempFinalVal+='${tempItemChip[i].toString().trim()};';
                                                                                }
                                                                                tempFinalVal=tempFinalVal.substring(0,tempFinalVal.length-1);
                                                                                comboCategoryItemsController.value[index]=tempFinalVal;
                                                                                print(comboCategoryItemsController.value);
                                                                                Navigator.pop(context);
                                                                              }
                                                                              else{
                                                                                showDialog(
                                                                                    context: context,
                                                                                    builder: (context) => AlertDialog(
                                                                                      title: Text("Error"),
                                                                                      content: Text("Add items"),
                                                                                      actions: <Widget>[
                                                                                        // usually buttons at the bottom of the dialog
                                                                                        new TextButton(
                                                                                          child: new Text("Close"),
                                                                                          onPressed: () {
                                                                                            Navigator.of(context).pop();
                                                                                          },
                                                                                        ),
                                                                                      ],
                                                                                    )
                                                                                );
                                                                              }
                                                                            },
                                                                            child: Text('Save',style: TextStyle(
                                                                              color: kFont1Color,
                                                                              fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                                                            ),),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                            ),
                                                          ),
                                                        ),
                                                  );
                                                }
                                                else{
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        title: Text("Error"),
                                                        content: Text("Category not selected"),
                                                        actions: <Widget>[
                                                          // usually buttons at the bottom of the dialog
                                                          new TextButton(
                                                            child: new Text("Close"),
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                          ),
                                                        ],
                                                      )
                                                  );
                                                }
                                              }
                                            ),
                                          ),
                                          DataCell(
                                            Obx(()=>DropdownButton(
                                            value: comboUomList[index].toString().trim(),// Not necessary for Option 1
                                            items: uomList.map((String val) {
                                              return DropdownMenuItem(
                                                child: Text(val.toString().trim(),style: TextStyle(
                                                    fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                    color: Colors.black
                                                ),),
                                                value: val.trim(),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              comboUomList[index]=newValue.toString();
                                            },
                                          )),),
                                          DataCell(TextField(
                                            controller: comboQtyController.value[index],
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),
                                            ],
                                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                                            decoration:  const InputDecoration(
                                              hintText: 'Qty',
                                              border: OutlineInputBorder(),
                                              disabledBorder: OutlineInputBorder(
                                              ),
                                              enabledBorder: OutlineInputBorder(),
                                            ),
                                          )),
                                          DataCell(GestureDetector(
                                            child: IconButton(
                                              onPressed: () {
                                                addCombo--;
                                                comboQtyController.value.removeAt(index);
                                                comboCategoryController.value.removeAt(index);
                                                comboUomList.removeAt(index);
                                                searchResult.value=[];
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ))
                                        ],
                                      );
                                    },
                                  ),
                                ),),
                              ),
                            ],
                          ),
                        ),),),
                      Container(
                          width: MediaQuery.of(context).size.width/3,
                          color: kItemContainer,
                          child:  Obx(()=> ListView.builder(
                            shrinkWrap: true,
                            itemCount: searchResultCategory.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: (){
                                  comboCategoryController.value[comboIndex.value].text=searchResultCategory[index];
                                  searchResultCategory.value=[];
                                },
                                child: new ListTile(
                                  title: new Text(searchResultCategory[index].toString()),
                                ),
                              );
                            },
                          ))
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 30.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black38,
                              style: BorderStyle.solid,
                              width: 0.80),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            hint: Text('  Tax List'),
                            value: tax,
                            items: taxNameList.map((value) {
                              return DropdownMenuItem(value: value, child: Text(value));
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                tax = newValue.toString();
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 30.0,
                        color: Colors.white,
                        child: TextField(
                          controller: itemDiscountController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black38, width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38, width: 1.0),
                            ),
                            labelText: 'Discount',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          onChanged: (value) {
                            discount = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 30.0,
                        color: Colors.white,
                        child: TextField(
                          controller: itemStockQtyController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black38, width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38, width: 1.0),
                            ),
                            labelText: 'Opening Stock',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 30.0,
                        color: Colors.white,
                        child: TextField(
                          controller: itemCostPriceController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black38, width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38, width: 1.0),
                            ),
                            labelText: 'Cost Price',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextButton(
                          onPressed: () async {
                            if (itemNameController.text == '' || tax == '' || selectedCategory == '') {
                              print('itemName $itemName');
                              print('tax $tax');
                              print('selectedCategory $selectedCategory');
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Error"),
                                    content: Text("Fill all the fields"),
                                    actions: <Widget>[
                                      // usually buttons at the bottom of the dialog
                                      new TextButton(
                                        child: new Text("Close"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ));
                            }
                            else {
                              String inside = 'not';
                              if(productEdit.value==false){
                                for (int i = 0; i < allProducts.length; i++) {
                                  if (allProducts[i].toLowerCase() ==
                                      itemName.toLowerCase().trim().replaceAll('/', '#')) {
                                    inside = 'contains';
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text("Error"),
                                          content: Text("Product name Exists"),
                                          actions: <Widget>[
                                            // usually buttons at the bottom of the dialog
                                            new TextButton(
                                              child: new Text("Close"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ));
                                  }
                                }
                              }

                              if (inside == 'not') {
                                for (int i = 0; i < selectedUomList.length; i++) {
                                  int sameUom = 0;
                                  for (int j = 0; j < selectedUomList.length; j++) {
                                    if (selectedUomList[i] == selectedUomList[j])
                                      sameUom++;
                                  }
                                  if (sameUom > 1) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            child: Text(
                                              'Invalid UOM List',
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                    .textScaleFactor *
                                                    20,
                                              ),
                                            ),
                                          );
                                        });
                                    return;
                                  }
                                }
                                String tempUom = '';
                                for (int i = 0; i < selectedUomList.length; i++) {
                                  tempUom += '${selectedUomList[i]}*';
                                  if (validCharacters.hasMatch(selectedUomList[i]) ==
                                      false) ite = true;
                                  print("selectedUomList[i]" + selectedUomList[i]);
                                }
                                tempUom += '``';
                                for (int i = 0; i < selectedUomList.length; i++) {
                                  if (sp[i].contains(',')) {
                                    sp[i] = sp[i].replaceAll(',', '>');
                                    if (validCharacters.hasMatch(sp[i]) == false)
                                      ite = true;
                                    print('sp ${sp[i]}');
                                  }
                                  tempUom += '${sp[i]}*';
                                }
                                tempUom += '``';
                                for (int i = 0; i < selectedUomList.length; i++) {
                                  tempUom += '${pp[i]}*';
                                  if (validCharacters.hasMatch(pp[i]) == false)
                                    ite = true;
                                  print('pp ${pp[i]}');
                                }
                                tempUom += '``';
                                for (int i = 0; i < selectedUomList.length; i++) {
                                  tempUom += '${barcode[i]}*';
                                  if (validCharacters.hasMatch(barcode[i]) == false)
                                    ite = true;
                                  print('barcode ${barcode[i]}');
                                }
                                tempUom += '``';
                                for (int i = 0; i < selectedUomList.length; i++) {
                                  tempUom += '${conversion[i]}*';
                                  if (validCharacters.hasMatch(conversion[i]) == false)
                                    ite = true;
                                  print('conversion ${conversion[i]}');
                                }
                                String tempBom='';
                                if( bomItemController.value.length>0){
                                  for (int i = 0; i < bomItemController.value.length; i++) {
                                    tempBom += '${bomItemController.value[i].text}*';
                                  }
                                  tempBom += '``';
                                  for (int i = 0; i < bomUomList.length; i++) {
                                    tempBom += '${bomUomList[i]}*';
                                  }
                                  tempBom += '``';
                                  for (int i = 0; i < bomQtyController.value.length; i++) {
                                    tempBom += '${bomQtyController.value[i].text}*';
                                  }
                                }
                                String tempCombo='';
                                if(isCombo.value){
                                if( comboCategoryController.value.length>0){
                                  for (int i = 0; i < comboCategoryController.value.length; i++) {
                                    tempCombo += '${comboCategoryController.value[i].text}>${comboCategoryItemsController.value[i]}*';
                                  }
                                  tempCombo += '``';
                                  for (int i = 0; i < comboUomList.length; i++) {
                                    tempCombo += '${comboUomList[i]}*';
                                  }
                                  tempCombo += '``';
                                  for (int i = 0; i < comboQtyController.value.length; i++) {
                                    tempCombo += '${comboQtyController.value[i].text}*';
                                  }
                                }
                                print('tempComboooo $tempCombo');
                              }
                                int count = 0;
                                String body =
                                    '${itemName.replaceAll('/', '#')}~$selectedCategory~$itemCode~$_character~$tempUom~$tax~$discount~$productImage~$provisionType~$tempBom~${isCombo.value}~$tempCombo';
                                if(productEdit.value==true){
                                    firebaseFirestore.collection('product_data').doc(docId).update(
                                        {
                                          'itemName': itemNameController.text.replaceAll('/', '#'),
                                          'category': selectedCategory,
                                          'itemCode':itemCodeController.text,
                                          'barcodeType': _character.toString(),
                                          'uom': tempUom,
                                          'tax': tax,
                                          'discount': itemDiscountController.text,
                                          'image': productImage.value,
                                          'provision': provisionType,
                                          'bom': tempBom,
                                          'isCombo': isCombo.value.toString(),
                                          'combo': tempCombo,
                                        });
                                    if(itemNameController.text!=oldItemName){
                                      String stockQuantity='';
                                      String costPrice='';
                                      String stockValue='';
                                      await firebaseFirestore.collection("stock").where('item',isEqualTo: oldItemName).get().then((querySnapshot) {
                                        querySnapshot.docs.forEach((result) {
                                          stockQuantity=result.get('qty');
                                          costPrice=result.get('cost');
                                          stockValue=result.get('value');
                                        });
                                      });
                                      await firebaseFirestore.collection("stock").doc(oldItemName).delete();
                                      await firebaseFirestore.collection("stock").doc(itemNameController.text).set({
                                        'item': itemNameController.text,
                                        'qty':stockQuantity,
                                        'cost':costPrice,
                                        'value':stockValue,
                                      }).then((_) {
                                        print('success');
                                      });
                                    }
                                }
                                else{
                                  print('inside create $body');
                                  double val=0;
                                  if(double.parse(itemStockQtyController.text)>0){
                                    val=double.parse(itemStockQtyController.text)*double.parse(itemCostPriceController.text);
                                  }
                                  String stockBody = '${itemName.replaceAll('/', '#')}~${itemStockQtyController.text}~${itemCostPriceController.text}~$val';
                                  create(body, 'product_data');
                                  create(stockBody, 'stock');
                                }
                                addImage.value=false;
                                productEdit.value=false;
                                isCombo.value=false;
                                productImage.value = '';
                                setState(() {
                                  itemNameController.clear();
                                  itemCodeController.clear();
                                  itemDiscountController.clear();
                                  itemStockQtyController.text='0';
                                  itemCostPriceController.text='0';
                                  discount = '';
                                  addUom = 0;
                                  itemName='';
                                  itemCode='';
                                  selectedUomList = [];
                                  sp = [];
                                  pp = [];
                                  barcode = [];
                                  conversion = [];
                                  spController=[];
                                  ppController=[];
                                  barcodeController=[];
                                  conversionController=[];
                                });
                                addBom.value=0;
                                addCombo.value=0;
                                bomUomList.value=[];
                                comboUomList.value=[];
                                bomItemController.value=RxList<TextEditingController>([]);
                                bomQtyController.value=RxList<TextEditingController>([]);
                                comboCategoryController.value=RxList<TextEditingController>([]);
                                comboQtyController.value=RxList<TextEditingController>([]);
                              }
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'SAVE',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).textScaleFactor * 20,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: kBackgroundColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ))
                    ],
                  ),
                ),
              )),
          Expanded(
            child:Container(
              decoration:  BoxDecoration(
                      color:Colors.white,
                  border: Border.all(color: kGreenColor)
              ),
              child: StreamBuilder(
                stream: firebaseFirestore
                    .collection('product_data').orderBy('itemName',descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  List items=[];
                  List id=[];
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*14,
                          ),
                          focusNode: nameNode,
                          controller: nameEditController,
                          decoration: new InputDecoration(
                              suffixIcon: IconButton(onPressed: () {
                                setState(() {
                                  nameEditController.clear();
                                });
                                searchResultItemSearch.clear();
                              },
                                  icon: Icon(Icons.clear,color: Colors.black,)),
                              // suffixIconColor: kBlack,
                              border: OutlineInputBorder(),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:Colors.black, width: 2.0
                                ),
                                // borderRadius:  BorderRadius.all(Radius.circular(32.0),)
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:Colors.black, width: 2.0
                                ),
                                // borderRadius:  BorderRadius.all(Radius.circular(32.0),)
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:Colors.black, width: 2.0
                                ),
                                // borderRadius:  BorderRadius.all(Radius.circular(32.0),)
                              ),
                              hintText: 'search for items'
                          ),
                          onChanged: searchCloud,
                        ),
                      ),
                      Expanded(
                        child: Obx(()=>Visibility(
                          visible: searchResultItemSearch.isEmpty,
                          replacement: Container(
                            // width: MediaQuery.of(context).size.width/3,
                              color: kItemContainer,
                              child:  Obx(()=> ListView.builder(
                                shrinkWrap: true,
                                itemCount: searchResultItemSearch.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0,right:8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: () async {
                                            DocumentSnapshot document=await firebaseFirestore.collection('product_data').doc(id[items.indexOf(searchResultItemSearch[index])]).get();
                                           List docLength=document.data().toString().split(',');
                                            nameEditController.text=searchResultItemSearch[index];
                                            productEdit.value=true;
                                            isCombo.value=false;
                                            addBom.value=0;
                                            bomUomList.value=[];
                                            comboUomList.value=[];
                                            bomItemController.value=RxList<TextEditingController>([]);
                                            comboCategoryController.value=RxList<TextEditingController>([]);
                                            bomQtyController.value=RxList<TextEditingController>([]);
                                            comboQtyController.value=RxList<TextEditingController>([]);
                                            comboCategoryItemsController.value=RxList<String>([]);
                                            setState(() {
                                              spController=[];
                                              ppController=[];
                                              barcodeController=[];
                                              conversionController=[];
                                              selectedUomList=[];
                                              sp=[];
                                              pp=[];
                                              barcode=[];
                                              conversion=[];
                                              docId=document.id;
                                              itemNameController.text=document['itemName'];
                                              oldItemName=document['itemName'];
                                              selectedCategory=document['category'];
                                              itemCodeController.text=document['itemCode'];
                                              _provision=document['provision']=='Both'?selectedProvision.Both:document['provision']=='Salable'?selectedProvision.Salable:selectedProvision.Purchasable;
                                              _character=document['barcodeType']=='selectedMode.Normal'?selectedMode.Normal:selectedMode.Weighted;
                                              itemDiscountController.text=document['discount'];
                                              tax=document['tax'];
                                              List temp1=document['uom'].toString().split('``');
                                              List tempUom=temp1[0].toString().split('*');
                                              List tempSp=temp1[1].toString().split('*');
                                              List tempPp=temp1[2].toString().split('*');
                                              List tempBarcode=temp1[3].toString().split('*');
                                              List tempConversion=temp1[4].toString().split('*');
                                              tempUom.removeLast();
                                              tempSp.removeLast();
                                              tempPp.removeLast();
                                              tempBarcode.removeLast();
                                              tempConversion.removeLast();
                                              for(int i=0;i<tempUom.length;i++){
                                                selectedUomList.add(tempUom[i]);
                                                spController.add(TextEditingController(text: tempSp[i]));
                                                ppController.add(TextEditingController(text: tempPp[i]));
                                                barcodeController.add(TextEditingController(text: tempBarcode[i]));
                                                conversionController.add(TextEditingController(text: tempConversion[i]));
                                                sp.add(tempSp[i]);
                                                pp.add(tempPp[i]);
                                                barcode.add(tempBarcode[i]);
                                                conversion.add(tempConversion[i]);
                                              }
                                              addUom=tempUom.length;
                                              nameEditController.clear();
                                            });
                                            productImage.value=document['image'];
                                            if(document['bom'].toString().isNotEmpty){
                                              List temp2=document['bom'].toString().split('``');
                                              List tempItem=temp2[0].toString().split('*');
                                              List tempUomBom=temp2[1].toString().split('*');
                                              List tempQty=temp2[2].toString().split('*');
                                              tempItem.removeLast();
                                              tempUomBom.removeLast();
                                              tempQty.removeLast();
                                              for(int i=0;i<tempItem.length;i++){
                                                bomItemController.value.add(TextEditingController(text: tempItem[i]));
                                                bomUomList.add(tempUomBom[i]);
                                                bomQtyController.value.add(TextEditingController(text: tempQty[i]));
                                              }
                                              addBom.value=tempItem.length;
                                            }
                                            if(docLength.length==12){
                                              isCombo.value=document['isCombo']=='true'?true:false;
                                              if(document['isCombo']=='true'){
                                                List temp2=document['combo'].toString().split('``');
                                                List tempCategory=temp2[0].toString().split('*');
                                                List tempUomCombo=temp2[1].toString().split('*');
                                                List tempQty=temp2[2].toString().split('*');
                                                tempCategory.removeLast();
                                                tempUomCombo.removeLast();
                                                tempQty.removeLast();
                                                for(int i=0;i<tempCategory.length;i++){
                                                  List temp99=tempCategory[i].toString().split('>');
                                                  comboCategoryController.value.add(TextEditingController(text: temp99[0].toString().trim()));
                                                  comboUomList.add(tempUomCombo[i]);
                                                  comboCategoryItemsController.value.add(temp99[1].toString().trim());
                                                  comboQtyController.value.add(TextEditingController(text: tempQty[i]));
                                                  print('comboCategoryController ${comboCategoryController.value[i].text}');
                                                }
                                                addCombo.value=tempCategory.length;
                                              }
                                            }
                                            searchResultItemSearch.clear();
                                            FocusScope.of(context).unfocus();
                                          },
                                          child:Text(searchResultItemSearch[index].toString().replaceAll('#', '/'),style: TextStyle(
                                              fontSize:
                                              MediaQuery.of(context).textScaleFactor *
                                                  15,
                                              color: kBlack
                                          ),),
                                        ),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            elevation: MaterialStateProperty.all(3.0),
                                            backgroundColor: MaterialStateProperty.all(kGreenColor),
                                          ),
                                          onPressed: (){
                                            showDialog(
                                              context: context,
                                              builder: (context) => new AlertDialog(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                                title: new Text('Are you sure?'),
                                                content: new Text('Invoice related to ${searchResultItemSearch[index]} cannot be edited'),
                                                actions: <Widget>[
                                                  new TextButton(
                                                    onPressed: () => Navigator.of(context).pop(false),
                                                    child: Container(
                                                        padding: EdgeInsets.all(6.0),
                                                        width: 100,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.circular(10.0),
                                                            border: Border.all(color: kBlack)
                                                        ),
                                                        child: Center(
                                                          child: Text("Cancel",style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.bold
                                                          ),),
                                                        )),
                                                  ),
                                                  SizedBox(height: 16),

                                                  new TextButton(
                                                    onPressed: ()  {
                                                      firebaseFirestore.collection('product_data').doc(id[items.indexOf(searchResultItemSearch[index])]).delete();
                                                      Navigator.pop(context);
                                                    } ,
                                                    child: Container(
                                                        padding: EdgeInsets.all(6.0),
                                                        width: 100,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.circular(10.0),
                                                            border: Border.all(color: kBlack)
                                                        ),
                                                        child: Center(child: Text("Delete",style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.bold
                                                        )))),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Icon(Icons.delete),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ))
                          ),
                          child: ListView(
                          scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: snapshot.data.docs.map((document) {
                              items.add(document['itemName']);
                              id.add(document.id);
                              return Padding(
                                padding:
                                const EdgeInsets.only(top: 4.0, bottom: 4.0,right:8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                        onPressed: () async {
                                          List docLength=document.data().toString().split(',');
                                          productEdit.value=true;
                                          isCombo.value=false;
                                          addBom.value=0;
                                          bomUomList.value=[];
                                          comboUomList.value=[];
                                          bomItemController.value=RxList<TextEditingController>([]);
                                          comboCategoryController.value=RxList<TextEditingController>([]);
                                          bomQtyController.value=RxList<TextEditingController>([]);
                                          comboQtyController.value=RxList<TextEditingController>([]);
                                          comboCategoryItemsController.value=RxList<String>([]);
                                          setState(() {
                                            spController=[];
                                            ppController=[];
                                            barcodeController=[];
                                            conversionController=[];
                                            selectedUomList=[];
                                            sp=[];
                                            pp=[];
                                            barcode=[];
                                            conversion=[];
                                            docId=document.id;
                                            itemNameController.text=document['itemName'];
                                            oldItemName=document['itemName'];
                                            selectedCategory=document['category'];
                                            itemCodeController.text=document['itemCode'];
                                            _provision=document['provision']=='Both'?selectedProvision.Both:document['provision']=='Salable'?selectedProvision.Salable:selectedProvision.Purchasable;
                                            _character=document['barcodeType']=='selectedMode.Normal'?selectedMode.Normal:selectedMode.Weighted;
                                            itemDiscountController.text=document['discount'];
                                            tax=document['tax'];
                                            List temp1=document['uom'].toString().split('``');
                                            List tempUom=temp1[0].toString().split('*');
                                            List tempSp=temp1[1].toString().split('*');
                                            List tempPp=temp1[2].toString().split('*');
                                            List tempBarcode=temp1[3].toString().split('*');
                                            List tempConversion=temp1[4].toString().split('*');
                                            tempUom.removeLast();
                                            tempSp.removeLast();
                                            tempPp.removeLast();
                                            tempBarcode.removeLast();
                                            tempConversion.removeLast();
                                            for(int i=0;i<tempUom.length;i++){
                                              selectedUomList.add(tempUom[i]);
                                              spController.add(TextEditingController(text: tempSp[i]));
                                              ppController.add(TextEditingController(text: tempPp[i]));
                                              barcodeController.add(TextEditingController(text: tempBarcode[i]));
                                              conversionController.add(TextEditingController(text: tempConversion[i]));
                                              sp.add(tempSp[i]);
                                              pp.add(tempPp[i]);
                                              barcode.add(tempBarcode[i]);
                                              conversion.add(tempConversion[i]);
                                            }
                                            addUom=tempUom.length;
                                          });
                                          productImage.value=document['image'];
                                          if(document['bom'].toString().isNotEmpty){
                                            List temp2=document['bom'].toString().split('``');
                                            List tempItem=temp2[0].toString().split('*');
                                            List tempUomBom=temp2[1].toString().split('*');
                                            List tempQty=temp2[2].toString().split('*');
                                            tempItem.removeLast();
                                            tempUomBom.removeLast();
                                            tempQty.removeLast();
                                            for(int i=0;i<tempItem.length;i++){
                                              bomItemController.value.add(TextEditingController(text: tempItem[i]));
                                              bomUomList.add(tempUomBom[i]);
                                              bomQtyController.value.add(TextEditingController(text: tempQty[i]));
                                            }
                                            addBom.value=tempItem.length;
                                          }
                                          if(docLength.length==12){
                                            isCombo.value=document['isCombo']=='true'?true:false;
                                            if(document['isCombo']=='true'){
                                              List temp2=document['combo'].toString().split('``');
                                              List tempCategory=temp2[0].toString().split('*');
                                              List tempUomCombo=temp2[1].toString().split('*');
                                              List tempQty=temp2[2].toString().split('*');
                                              tempCategory.removeLast();
                                              tempUomCombo.removeLast();
                                              tempQty.removeLast();
                                              for(int i=0;i<tempCategory.length;i++){
                                                List temp99=tempCategory[i].toString().split('>');
                                                comboCategoryController.value.add(TextEditingController(text: temp99[0].toString().trim()));
                                                comboUomList.add(tempUomCombo[i]);
                                                comboCategoryItemsController.value.add(temp99[1].toString().trim());
                                                comboQtyController.value.add(TextEditingController(text: tempQty[i]));
                                                print('comboCategoryController ${comboCategoryController.value[i].text}');
                                              }
                                              addCombo.value=tempCategory.length;
                                            }
                                          }
                                        },
                                        child: Text(
                                          document['itemName'].toString().replaceAll('#', '/'),
                                          style: TextStyle(
                                            fontSize:
                                            MediaQuery.of(context).textScaleFactor *
                                                15,
                                            color: kBlack
                                          ),
                                        )),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        elevation: MaterialStateProperty.all(3.0),
                                        backgroundColor: MaterialStateProperty.all(kGreenColor),
                                      ),
                                      onPressed: (){
                                        showDialog(
                                          context: context,
                                          builder: (context) => new AlertDialog(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                            title: new Text('Are you sure?'),
                                            content: new Text('Invoice related to ${document['itemName']} cannot be edited'),
                                            actions: <Widget>[
                                              new TextButton(
                                                onPressed: () => Navigator.of(context).pop(false),
                                                child: Container(
                                                    padding: EdgeInsets.all(6.0),
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(10.0),
                                                        border: Border.all(color: kBlack)
                                                    ),
                                                    child: Center(
                                                      child: Text("Cancel",style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.bold
                                                      ),),
                                                    )),
                                              ),
                                              SizedBox(height: 16),

                                              new TextButton(
                                                onPressed: ()  {
                                                  firebaseFirestore.collection('product_data').doc(document.id).delete();
                                                  Navigator.pop(context);
                                                } ,
                                                child: Container(
                                                    padding: EdgeInsets.all(6.0),
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(10.0),
                                                        border: Border.all(color: kBlack)
                                                    ),
                                                    child: Center(child: Text("Delete",style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold
                                                    )))),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: Center(child: Icon(Icons.delete,size: 20,color: Colors.white,)),
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                          )
                        )),

                      ),
                    ],
                  );
                }),
            ) ,)
        ],
      );
    }
    else if (index == 1) {
      return Container(
        padding: EdgeInsets.all(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'UOM Details',
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: MediaQuery.of(context).textScaleFactor * 40,
                color: kBackgroundColor,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 3,
              height: 30.0,
              color: Colors.white,
              child: TextField(
                controller: uomNameController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.black38, width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38, width: 1.0),
                    ),
                    labelText: 'UOM Name ',
                    labelStyle: TextStyle(
                      color: Colors.black38,
                    )),
                onChanged: (value) {
                  uomName = value;
                },
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: TextButton(
                onPressed: () async {
                  if(uomName==''){
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Error"),
                          content: Text("Fill all the fields"),
                          actions: <Widget>[
                            // usually buttons at the bottom of the dialog
                            new TextButton(
                              child: new Text("Close"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        )
                    );
                  }
                  else{
                    String inside='not';
                    for(int i=0;i<uomList.length;i++){
                      if(uomList[i].toLowerCase() == uomName.toLowerCase().trim()){
                        inside='contains';
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Error"),
                              content: Text("UOM name Exists"),
                              actions: <Widget>[
                                // usually buttons at the bottom of the dialog
                                new TextButton(
                                  child: new Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            )
                        );
                      }
                    }
                    if(inside=='not'){
                      setState(() {
                        uomList.add(uomName);
                        uomNameController.clear();
                      });
                      create(uomName, 'uom_data');
                      //await insertData(body.substring(0,body.length-1),'uom_data');
                      uomName='';
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'SAVE',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor * 20,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
    else if (index == 2) {
      return Container(
        padding: EdgeInsets.all(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Details',
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: MediaQuery.of(context).textScaleFactor * 40,
                color: kBackgroundColor,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 3,
              height: 30.0,
              color: Colors.white,
              child: TextField(
                controller: categoryNameController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.black38, width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38, width: 1.0),
                    ),
                    labelText: 'Category Name',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    )),
                onChanged: (value) {
                  categoryName = value;
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () async {

                  await create(categoryName, 'category_data');
                  setState(() {
                    categoryName = '';
                    categoryNameController.clear();
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'SAVE',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor * 20,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ))
          ],
        ),
      );
    }
    else if (index == 3) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.all(50.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tax Details',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: MediaQuery.of(context).textScaleFactor * 40,
                    color: kBackgroundColor,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: 30.0,
                  color: Colors.white,
                  child: TextField(
                    controller: taxNameController,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.black38, width: 1.0)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black38, width: 1.0),
                        ),
                        labelText: 'Tax Name',
                        labelStyle: TextStyle(
                          color: Colors.black,
                        )),
                    onChanged: (value) {
                      taxName = value;
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: 30.0,
                  color: Colors.white,
                  child: TextField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    controller: percentageController,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.black38, width: 1.0)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black38, width: 1.0),
                        ),
                        labelText: 'Tax Percentage',
                        labelStyle: TextStyle(
                          color: Colors.black,
                        )),
                    onChanged: (value) {
                      percentage = value;
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: () async {
                      if(taxName==''|| percentage=='' ){
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Error"),
                              content: Text("Fill all the fields"),
                              actions: <Widget>[
                                // usually buttons at the bottom of the dialog
                                new TextButton(
                                  child: new Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            )
                        );
                      }
                      else{
                        String inside='not';
                        for(int i=0;i<taxNameList.length;i++){
                          if(taxNameList[i].toLowerCase() == taxName.toLowerCase().trim()){
                            inside='contains';
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Error"),
                                  content: Text("Tax name Exists"),
                                  actions: <Widget>[
                                    // usually buttons at the bottom of the dialog
                                    new TextButton(
                                      child: new Text("Close"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                )
                            );
                          }
                        }
                        if(inside=='not'){
                          String body='$taxName~$percentage~';
                          create(body, 'tax_data');
                          setState(() {
                            taxNameList.add(taxName);
                            percentageList.add(percentage);
                          });
                          taxName='';
                          percentage='';
                          taxNameController.clear();
                          percentageController.clear();
                        }
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'SAVE',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor * 20,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: kBackgroundColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ))
              ],
            ),
          ),
        ),
      );
    }
    else if (index == 4) {
      if(userEdit==false){
        if(selectedUserPrinter=='Network' || selectedUserPrinter=='Bluetooth'){
          if(selectedUserPrinter=='Network'){
            print('inside network if');
            selectedUserPrinterName.value=allNetwork.isEmpty?'':allNetwork[0];
          }
          else  if(selectedUserPrinter=='Bluetooth'){
            selectedUserPrinterName.value=allBluetooth.isEmpty?'':allBluetooth[0];
          }
        }
      }
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: EdgeInsets.all(50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Details',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: MediaQuery.of(context).textScaleFactor * 40,
                        color: kBackgroundColor,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 30.0,
                      color: Colors.white,
                      child: TextField(
                        controller: userNameController,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black38, width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38, width: 1.0),
                            ),
                            labelText: 'User Name',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            )),
                        onChanged: (value) {
                          userName = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 30.0,
                      color: Colors.white,
                      child: TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black38, width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38, width: 1.0),
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            )),
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 30.0,
                      color: Colors.white,
                      child: TextField(
                        maxLength: 2,
                        controller: prefixController,
                        decoration: InputDecoration(
                            counterText: '',
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black38, width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38, width: 1.0),
                            ),
                            labelText: 'Prefix',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            )),
                        onChanged: (value) {
                          prefix = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 30.0,
                      color: Colors.white,
                      child: TextField(
                        //maxLength: 2,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        controller: userStartFromController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            counterText: '',
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black38, width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38, width: 1.0),
                            ),
                            labelText: 'Invoice From',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            )),
                        onChanged: (value) {
                          userStartFrom = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 30.0,
                      color: Colors.white,
                      child: TextField(
                        //maxLength: 2,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        controller: userOrderFromController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            counterText: '',
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black38, width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38, width: 1.0),
                            ),
                            labelText: 'Order From',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            )),
                        onChanged: (value) {
                          userOrderFrom = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 30.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black38,
                            style: BorderStyle.solid,
                            width: 0.80),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: Text('  Terminal List'),
                          value: selectedTerminal,
                          items: terminalList.map((value) {
                            return DropdownMenuItem(value: value, child: Text(value));
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedTerminal = newValue.toString();
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 30.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black38,
                            style: BorderStyle.solid,
                            width: 0.80),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: Text('  Printer List'),
                          value: selectedUserPrinter,
                          items: userPrinterList.map((value) {
                            return DropdownMenuItem(value: value, child: Text(value));
                          }).toList(),
                          onChanged: (newValue) {
                            selectedUserPrinter=newValue.toString();
                            setState(() {
                              if(selectedUserPrinter=='Network' || selectedUserPrinter=='Bluetooth'){
                                if(selectedUserPrinter=='Network'){
                                  print('inside network if');
                                 selectedUserPrinterName.value=allNetwork.isEmpty?'':allNetwork[0];
                                }
                              else  if(selectedUserPrinter=='Bluetooth'){
                                  selectedUserPrinterName.value=allBluetooth.isEmpty?'':allBluetooth[0];
                                }
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if(selectedUserPrinter=='Network' || selectedUserPrinter=='Bluetooth')
                   Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 30.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black38,
                            style: BorderStyle.solid,
                            width: 0.80),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: selectedUserPrinter=='Network'?
                        Obx(()=>DropdownButton(
                          hint: Text('  Printer Name List'),
                          value: selectedUserPrinterName.value,
                          items: allNetwork.map((value) {
                            return DropdownMenuItem(value: value, child: Text(value));
                          }).toList(),
                          onChanged: (newValue) {
                            selectedUserPrinterName.value = newValue.toString();
                            print('selectedUserPrinterName ${selectedUserPrinterName.value}');
                          },
                        )):
                        Obx(()=>DropdownButton(
                          hint: Text('  Printer Name List'),
                          value: selectedUserPrinterName.value,
                          items: allBluetooth.map((value) {
                            return DropdownMenuItem(value: value, child: Text(value));
                          }).toList(),
                          onChanged: (newValue) {
                            selectedUserPrinterName.value = newValue.toString();
                            print('selectedUserPrinterName ${selectedUserPrinterName.value}');
                          },
                        )),
                      )
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(children: [
                            Text(
                            'Discount',
                            style: TextStyle(fontSize: 17.0),
                            ), //Text
                            SizedBox(width: 10), //S
                      Obx(()=>  Checkbox(
                        value: userDiscount.value,
                        onChanged: (bool value){
                          userDiscount.value = value;
                        },
                      ),),
                    ],),
                    Row(children: [
                            Text(
                            'Price Edit',
                            style: TextStyle(fontSize: 17.0),
                            ), //Text
                            SizedBox(width: 10), //Sized
                      Obx(()=> Checkbox(
                        value: userPriceEdit.value,
                        onChanged: (bool value) {
                          userPriceEdit.value = value;
                        },
                      ),)   ,

                    ],),
                      SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 30.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black38,
                            style: BorderStyle.solid,
                            width: 0.80),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: Text('  Warehouse List'),
                          value: selectedWarehouse,
                          items: warehouseList.map((value) {
                            return DropdownMenuItem(value: value, child: Text(value));
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedWarehouse = newValue.toString();
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: selectedTerminal=='Admin-POS'?true:selectedTerminal=='POS'?true:false,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 30.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black38,
                              style: BorderStyle.solid,
                              width: 0.80),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            hint: Text('  Branch List'),
                            value: selectedBranch,
                            items: branchList.map((value) {
                              return DropdownMenuItem(value: value, child: Text(value));
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedBranch = newValue.toString();
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        onPressed: () async {
                          if(userName==''|| password=='' || prefix=='' || userStartFrom=='' || userOrderFrom==''){
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Error"),
                                  content: Text("Fill all the fields"),
                                  actions: <Widget>[
                                    // usually buttons at the bottom of the dialog
                                    new TextButton(
                                      child: new Text("Close"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                )
                            );
                          }
                          else{
                            String inside='not';
                            for(int i=0;i<userNameList.length;i++){
                              if(userNameList[i].toLowerCase() == userName.toLowerCase().trim()){
                                inside='contains';
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Error"),
                                      content: Text("User name Exists"),
                                      actions: <Widget>[
                                        // usually buttons at the bottom of the dialog
                                        new TextButton(
                                          child: new Text("Close"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    )
                                );
                              }
                            }
                            if(inside=='not'){
                              String tempBranch=selectedTerminal=='Admin-POS'?selectedBranch:selectedTerminal=='POS'?selectedBranch:'';
                              String body='$userName~$password~$selectedTerminal~$prefix~$userStartFrom~$userOrderFrom~$selectedWarehouse~$selectedUserPrinter~$tempBranch~${selectedUserPrinterName.value}~${userDiscount.value}~${userPriceEdit.value}';
                              if(userEdit==true){
                                firebaseFirestore.collection('user_data').doc(userName).update(
                                    {
                                      'userName': userName,
                                      'password': password,
                                      'terminal': selectedTerminal,
                                      'prefix': prefix,
                                      'tillClose':tillClose,
                                      'startFrom': int.parse(userStartFrom),
                                      'orderFrom': int.parse(userOrderFrom),
                                      'tillCloseDate': tillCloseDate,
                                      'warehouse':selectedWarehouse,
                                      'printer':selectedUserPrinter,
                                      'branch':tempBranch,
                                      'printerName':selectedUserPrinterName.value,
                                      'discount': '${userDiscount.value}',
                                      'priceEdit':'${userPriceEdit.value}'
                                    }
                                );
                                userEdit=false;
                              }
                              else{
                                create(body, 'user_data');
                                setState(() {
                                  userNameList.add(userName);
                                  passwordList.add(password);
                                  prefixList.add(prefix);
                                });
                              }
                              userName='';
                              password='';
                              prefix='';
                              userStartFrom='';
                              userOrderFrom='';
                              userNameController.clear();
                              passwordController.clear();
                              prefixController.clear();
                              userStartFromController.clear();
                              userOrderFromController.clear();
                              userDiscount.value=false;
                              userPriceEdit.value=false;
                            }
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'SAVE',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor * 20,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: kBackgroundColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
          Expanded(child:StreamBuilder(
              stream: firebaseFirestore
                  .collection('user_data')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: snapshot.data.docs.map((document) {
                    return Padding(
                      padding:
                      const EdgeInsets.only(top: 4.0, bottom: 4.0),
                      child: TextButton(
                          onPressed: ()  {
                            selectedUserPrinterName.value=document['printerName'];
                            setState(() {
                              userEdit=true;
                              userName=   userNameController.text= document['userName'];
                              password=  passwordController.text=document['password'];
                              prefix= prefixController.text=document['prefix'];
                              userStartFrom=  userStartFromController.text=document['startFrom'].toString();
                              userOrderFrom=userOrderFromController.text=document['orderFrom'].toString();
                              selectedTerminal=document['terminal'];
                              selectedWarehouse=document['warehouse'];
                              tillCloseDate=document['tillCloseDate'];
                              tillClose=double.parse(document['tillClose'].toString());
                              selectedUserPrinter=document['printer'];
                            });
                            userDiscount.value=document['discount']=='true'?true:false;
                            userPriceEdit.value=document['priceEdit']=='true'?true:false;

                            print('selectedUserPrinterName ${selectedUserPrinterName.value}');
                          },
                          child: Text(
                            document['userName'],
                            style: TextStyle(
                              color: kBackgroundColor,
                              fontSize:
                              MediaQuery.of(context).textScaleFactor *
                                  15,
                            ),
                          )),
                    );
                  }).toList(),
                );
              }) ,)
        ],
      );
    }
    else if(index==5){
      return Container(
        padding: EdgeInsets.all(50.0),
        child: ListView(
          children: [
            DataTable(columns:[ DataColumn(label: Text(
              'Transaction Type',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).textScaleFactor * 20,
              ),
            ),
            ),
              DataColumn(label: Text(
                'Prefix',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).textScaleFactor * 20,
                ),
              ),
              ),
              DataColumn(label: Text(
                'Start From',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).textScaleFactor * 20,
                ),
              ),
              ),

            ], rows: List.generate(type.length, (indexSeq) => DataRow(cells:[
              DataCell(Text(
                type[indexSeq],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).textScaleFactor * 20,
                ),
              ),
              ),
              DataCell(TextField(

                controller: seqPrefixController[indexSeq],
                onChanged: (value){
                  transactionTypePrefix[indexSeq]=value;
                  print(transactionTypePrefix[indexSeq]);
                },
              ),
                showEditIcon: true,),
              DataCell(TextField(
                controller: fromController[indexSeq],
                onChanged: (value){
                  transactionTypeFrom[indexSeq]=value;
                  print(transactionTypeFrom[indexSeq]);
                },
              ),
                showEditIcon: true,
              ),
            ]))),
            SizedBox(height: 20.0,),
            TextButton(onPressed: () async {
              String temp='';
              String countTemp='';
              for(int i=0;i<type.length;i++){
                temp+='${transactionTypePrefix[i]}:${transactionTypeFrom[i]}~';
                countTemp+='${transactionTypeFrom[i]}~';
              }
              print('sequence body $temp');
              create(temp, 'sequence');
              create(countTemp, 'count');
              // await insertData(temp,'sequence_manager');
              // allFile.writeFile(temp, 'sequence_data');
            }, child: Container(
              decoration: BoxDecoration(
                color: kBackgroundColor,
              ),
              padding: EdgeInsets.all(8.0),
              child: Text('SAVE',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.5,
                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                ),
              ),
            ))
          ],
        ),
      );
    }
    else if(index==6){
      print('branchhh $branchList');
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.all(50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Organisation Details',
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: MediaQuery.of(context).textScaleFactor * 40,
                  color: kBackgroundColor,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: 30.0,
                color: Colors.white,
                child: TextField(
                  controller: orgNameController,
                  onChanged: (value){
                    orgName=value;
                  },
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black38, width: 1.0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black38, width: 1.0),
                      ),
                      labelText: 'Organisation Name',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: 30.0,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black38,
                      style: BorderStyle.solid,
                      width: 0.80),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value:selectedBusiness.trim() , // Not necessary for Option 1
                    items: businessTypes.map((String val) {
                      return DropdownMenuItem(
                        child: new Text(val.toString()),
                        value: val,
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedBusiness = newValue.toString();
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: 30.0,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black38,
                      style: BorderStyle.solid,
                      width: 0.80),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value:selectScreen.trim() , // Not necessary for Option 1
                    items: screenList.map((String val) {
                      return DropdownMenuItem(
                        child: new Text(val.toString()),
                        value: val,
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectScreen = newValue.toString();
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                // height: 100.0,
                color: Colors.white,
                child: TextField(
                  maxLines: 5,
                  controller: orgAddressController,
                  onChanged: (value){
                    orgAddress=value;
                  },
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black38, width: 1.0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black38, width: 1.0),
                      ),
                      labelText: 'Address',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: 30.0,
                color: Colors.white,
                child: TextField(
                  controller: orgMobileNoController,
                  onChanged: (value){
                    orgMobileNo=value;
                  },
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black38, width: 1.0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black38, width: 1.0),
                      ),
                      labelText: 'Mobile Number',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: 30.0,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black38,
                      style: BorderStyle.solid,
                      width: 0.80),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value:selectedTax.trim() , // Not necessary for Option 1
                    items: taxTypeList.map((String val) {
                      return DropdownMenuItem(
                        child: new Text(val.toString()),
                        value: val,
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedTax = newValue.toString();
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: 30.0,
                color: Colors.white,
                child: TextField(
                  controller: orgTaxTitleController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black38, width: 1.0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black38, width: 1.0),
                      ),
                      labelText: 'Tax Title',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: 30.0,
                color: Colors.white,
                child: TextField(
                  controller: orgVatNoController,
                  onChanged: (value){
                    orgVatNo=value;
                  },
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black38, width: 1.0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black38, width: 1.0),
                      ),
                      labelText: 'VAT/GST NO',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: 30.0,
                color: Colors.white,
                child: TextField(
                  controller: currencyController,
                  onChanged: (value){
                    currency=value;
                  },
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black38, width: 1.0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black38, width: 1.0),
                      ),
                      labelText: 'Currency',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: 30.0,
                color: Colors.white,
                child: TextField(
                  controller: symbolController,
                  onChanged: (value){
                    symbol=value;
                  },
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black38, width: 1.0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black38, width: 1.0),
                      ),
                      labelText: 'Symbol',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: 30.0,
                color: Colors.white,
                child: TextField(
                  controller: orgDecimalsController,
                  onChanged: (value){
                    orgDecimals=value;
                  },
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black38, width: 1.0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black38, width: 1.0),
                      ),
                      labelText: 'Decimals',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(children:[
                Text('Close day extended hour',style: TextStyle(
                    fontWeight: FontWeight.bold
                  //  fontSize: MediaQuery.of(context).textScaleFactor * 20,
                ),),
                SizedBox(width:20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: kAppBarItems,
                        style: BorderStyle.solid,
                        width: 1),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton(
                        dropdownColor:Colors.white,
                        isDense: true,
                        value: selectedCloseHour, // Not necessary for Option 1
                        items: closedHourList.map((String val) {
                          return DropdownMenuItem(
                            child: new Text(val.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                  fontSize: MediaQuery.of(context).textScaleFactor*18,
                                  color: kHighlight
                              ),
                            ),
                            value: val,
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState((){
                            selectedCloseHour=newValue;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ]),
              SizedBox(
                height: 20,
              ),
              Row(children: [
                Text('Invoice Edit',style: TextStyle(
                    fontWeight: FontWeight.bold
                  //  fontSize: MediaQuery.of(context).textScaleFactor * 20,
                ),),
                Obx(()=>  Checkbox(
                  value: orgInvEdit.value,
                  onChanged: (bool value){
                    orgInvEdit.value = value;
                  },
                ),),
              ],),
              Row(children: [
                Text('Composite Tax Dealer',style: TextStyle(
                    fontWeight: FontWeight.bold
                  //  fontSize: MediaQuery.of(context).textScaleFactor * 20,
                ),),
                Obx(()=>  Checkbox(
                  value: orgCompositeTax.value,
                  onChanged: (bool value){
                    orgCompositeTax.value = value;
                  },
                ),),
              ],),

              Row(children: [
                Text('Call Center',style: TextStyle(
                    fontWeight: FontWeight.bold
                  //  fontSize: MediaQuery.of(context).textScaleFactor * 20,
                ),),
                Obx(()=>  Checkbox(
                  value: orgCallCenter.value,
                  onChanged: (bool value){
                    orgCallCenter.value = value;
                  },
                ),),
              ],),
              Row(children: [
                Text('MultiLine Invoice',style: TextStyle(
                    fontWeight: FontWeight.bold
                  //  fontSize: MediaQuery.of(context).textScaleFactor * 20,
                ),),
                Obx(()=>  Checkbox(
                  value: orgMultiLineInvoice.value,
                  onChanged: (bool value){
                    orgMultiLineInvoice.value = value;
                  },
                ),),
              ],),
              Row(children: [
                Text('QR Code',style: TextStyle(
                    fontWeight: FontWeight.bold
                  //  fontSize: MediaQuery.of(context).textScaleFactor * 20,
                ),),
                Obx(()=>  Checkbox(
                  value: orgQRCode.value,
                  onChanged: (bool value){
                    orgQRCode.value = value;
                  },
                ),),
              ],),
              if(selectedBusiness=='Restaurant')
              Row(children: [
                Text('Waiter Checkout',style: TextStyle(
                    fontWeight: FontWeight.bold
                  //  fontSize: MediaQuery.of(context).textScaleFactor * 20,
                ),),
                Obx(()=>  Checkbox(
                  value: orgWaiterCheckout.value,
                  onChanged: (bool value){
                    orgWaiterCheckout.value = value;
                  },
                ),),
              ],),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Invoice Print',style: TextStyle(
                      fontWeight: FontWeight.bold
                    //  fontSize: MediaQuery.of(context).textScaleFactor * 20,
                  ),),
                  RadioListTile(
                      activeColor: kBackgroundColor,
                      title: Text(
                        'One',
                        style: TextStyle(
                          // fontSize: MediaQuery.of(context).textScaleFactor * 20,
                        ),
                      ),
                      value: selectedInvoicePrint.One,
                      groupValue: _invoicePrint,
                      onChanged: (value) {
                        setState(() {
                          _invoicePrint = value as selectedInvoicePrint;
                          invPrint = 'One';
                        });
                      }),
                  RadioListTile(
                      activeColor: kBackgroundColor,
                      title: Text(
                        'Two',
                        style: TextStyle(
                          //  fontSize: MediaQuery.of(context).textScaleFactor * 20,
                        ),
                      ),
                      value:selectedInvoicePrint.Two,
                      groupValue: _invoicePrint,
                      onChanged: (value) {
                        setState(() {
                          _invoicePrint = value as selectedInvoicePrint;
                          invPrint = 'Two';
                        });
                      }),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Divider(thickness: 1.0,color: kLightBlueColor,),
              Row(
                children: [
                    Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration:  BoxDecoration(
                          border: Border.all(color: kGreenColor)
                      ),
                      child: Column(children: [
                        TextButton(
                            onPressed: (){
                              setState(() {
                                addWarehouse++;
                                warehouseController.add(TextEditingController(text: ''));
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: kBackgroundColor,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text('Add Warehouse',
                                style: TextStyle(
                                  //letterSpacing: 1.5,
                                    fontSize: MediaQuery.of(context).textScaleFactor*16,
                                    color: Colors.white
                                ),
                              ),
                            )
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width/3,
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: addWarehouse,
                              itemBuilder: (context,index){
                                return   Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: TextField(
                                          controller: warehouseController[index],
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).textScaleFactor*16,
                                          ),
                                          decoration: const InputDecoration(
                                            label: Text('Enter warehouse name'),
                                            isDense: true,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:Colors.black, width: 2.0
                                              ),
                                              // borderRadius:  BorderRadius.all(Radius.circular(32.0),)
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black, width: 2.0),
                                              //  borderRadius:  BorderRadius.all(Radius.circular(32.0),)
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            addWarehouse--;
                                            warehouseController.removeAt(index);
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              }),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],),
                    ),
                  ),
                  SizedBox(width:20),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration:  BoxDecoration(
                          border: Border.all(color: kGreenColor)
                      ),
                      child: Column(children: [
                        TextButton(
                            onPressed: (){
                              setState(() {
                                addBranch++;
                                branchController.add(TextEditingController(text: ''));
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: kBackgroundColor,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text('Add Branch',
                                style: TextStyle(
                                  //letterSpacing: 1.5,
                                    fontSize: MediaQuery.of(context).textScaleFactor*16,
                                    color: Colors.white
                                ),
                              ),
                            )
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width/3,
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: addBranch,
                              itemBuilder: (context,index){
                                return   Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: TextField(
                                          controller: branchController[index],
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).textScaleFactor*16,
                                          ),
                                          decoration: const InputDecoration(
                                            label: Text('Enter Branch name'),
                                            isDense: true,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:Colors.black, width: 2.0
                                              ),
                                              // borderRadius:  BorderRadius.all(Radius.circular(32.0),)
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black, width: 2.0),
                                              //  borderRadius:  BorderRadius.all(Radius.circular(32.0),)
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            addBranch--;
                                            branchController.removeAt(index);
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              }),
                        ),
                        SizedBox(height: 20,),
                      ],),
                    ),
                  ),
                ],
              ),
              Divider(thickness: 1.0,color: kLightBlueColor,),
              TextButton(onPressed: (){
                String body='$orgName~$selectedBusiness~$orgAddress~$orgMobileNo~$orgVatNo~$currency~$symbol~$orgDecimals~$selectScreen~$selectedTax~${orgTaxTitleController.text}~$invPrint~$callCenterEnable~${orgInvEdit.value}~${orgCallCenter.value}~${orgMultiLineInvoice.value}~${orgQRCode.value}~${orgCompositeTax.value}~$selectedCloseHour~${orgWaiterCheckout.value}';
                // decimals=int.parse(orgDecimals);
                print('org body $body');
                create(body, 'organisation');
                if(addWarehouse>0){
                  print('addWarehouse $addWarehouse');
                  print('warehouseList $warehouseList');
                  for(int i=0;i<addWarehouse;i++){
                    if(warehouseList.asMap().containsKey(i)){
                      print('inside else iffffffffff');
                      if(warehouseList[i]==warehouseController[i].text){
                        continue;
                      }
                      else{
                        print('inside else iffffffffff ${warehouseList[i]}');
                        firebaseFirestore.collection('warehouse').doc(warehouseList[i]).delete();
                        create(warehouseController[i].text, 'warehouse');
                        warehouseList[i]=warehouseController[i].text;
                      }
                    }
                    else{
                      create(warehouseController[i].text, 'warehouse');
                      warehouseList.add(warehouseController[i].text);
                    }
                  }
                 if(addWarehouse<warehouseList.length){
                  for(int i=addWarehouse;i<warehouseList.length;i++){
                    firebaseFirestore.collection('warehouse').doc(warehouseList[i]).delete();
                  }
                }
                }
                else if(addWarehouse<warehouseList.length){
                  for(int i=addWarehouse;i<warehouseList.length;i++){
                    firebaseFirestore.collection('warehouse').doc(warehouseList[i]).delete();
                  }
                }
                /////branch
                if(addBranch>0){
                  for(int i=0;i<addBranch;i++){
                    if(branchList.asMap().containsKey(i)){
                      if(branchList[i]==branchController[i].text){
                        continue;
                      }
                      else{
                        firebaseFirestore.collection('branch_data').doc(branchList[i]).delete();
                        create(branchController[i].text, 'branch_data');
                        branchList[i]=branchController[i].text;
                      }
                    }
                    else{
                      create(branchController[i].text, 'branch_data');
                      branchList.add(branchController[i].text);
                    }
                  }
                 if(addBranch<branchList.length){
                  for(int i=addBranch;i<branchList.length;i++){
                    firebaseFirestore.collection('branch_data').doc(branchList[i]).delete();
                  }
                }
                }
                else if(addBranch<branchList.length){
                  for(int i=addBranch;i<branchList.length;i++){
                    firebaseFirestore.collection('branch_data').doc(branchList[i]).delete();
                  }
                }
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(""),
                      content: Text("Completed"),
                      actions: <Widget>[
                        // usually buttons at the bottom of the dialog
                        new TextButton(
                          child: new Text("Close"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    )
                );
                // getOrganisationData();
              }, child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: kBackgroundColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text('SUBMIT',
                  style: TextStyle(
                      letterSpacing: 1.5,
                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                      color: Colors.white
                  ),
                ),
              ))
            ],
          ),
        ),
      );
    }
    else if(index==7){
      return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex:2,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child:Container(
                padding: EdgeInsets.all(50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: MediaQuery.of(context).textScaleFactor * 40,
                        color: kBackgroundColor,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,

                      color: Colors.white,
                      child:  TextField(
                        controller: customerNameController,
                        onChanged: (value){
                          customerName=value;
                        },
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black38, width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38, width: 1.0),
                            ),
                            labelText: 'Customer Name',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      // height: 100.0,
                      color: Colors.white,
                      child: TextField(
                        maxLines: 3,
                        controller: customerAddressController,
                        onChanged: (value){
                          address=value;
                        },
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black38, width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38, width: 1.0),
                            ),
                            labelText: 'Address',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            )),
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: flatNoController,
                              onChanged: (value) {
                              },
                              keyboardType:
                              TextInputType.name,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.black38, width: 1.0)),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black38, width: 1.0),
                                  ),
                                  labelText: 'FLAT NO',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                  )),
                            ),
                          ),
                          SizedBox(width: 10.0,),
                          Expanded(
                            child: TextField(
                              controller: buildNoController,
                              onChanged: (value) {
                              },
                              keyboardType:
                              TextInputType.name,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.black38, width: 1.0)),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black38, width: 1.0),
                                  ),
                                  labelText: 'BLD NO',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: roadNoController,
                              onChanged: (value) {
                              },
                              keyboardType:
                              TextInputType.name,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.black38, width: 1.0)),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black38, width: 1.0),
                                  ),
                                  labelText: 'ROAD NO',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                  )),
                            ),
                          ),
                          SizedBox(width: 10.0,),
                          Expanded(
                            child: TextField(
                              controller: blockNoController,
                              onChanged: (value) {
                              },
                              keyboardType:
                              TextInputType.name,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.black38, width: 1.0)),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black38, width: 1.0),
                                  ),
                                  labelText: 'BLOCK NO',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: TextField(
                        controller: areaNoController,
                        onChanged: (value) {
                        },
                        keyboardType:
                        TextInputType.name,
                        maxLines: 3,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black38, width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38, width: 1.0),
                            ),
                            labelText: 'Area',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            )),
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: TextField(
                        controller: landmarkNoController,
                        onChanged: (value) {
                        },
                        keyboardType:
                        TextInputType.name,
                        maxLines: 3,
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black38, width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38, width: 1.0),
                            ),
                            labelText: 'Landmark',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            )),
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: TextField(
                        controller: customerNoteController,
                        onChanged: (value) {
                        },
                        keyboardType:
                        TextInputType.name,
                        maxLines: 3,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black38, width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38, width: 1.0),
                            ),
                            labelText: 'Note',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            )),
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 30.0,
                      color: Colors.white,
                      child: TextField(
                        controller: customerMobileController,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (value){
                          mobile=value;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black38, width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38, width: 1.0),
                            ),
                            labelText: 'Mobile Number',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 30.0,
                      color: Colors.white,
                      child: TextField(
                        controller: customerVatController,
                        onChanged: (value){
                          vat=value;
                        },
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black38, width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38, width: 1.0),
                            ),
                            labelText: 'VAT/GST NO',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 30.0,
                      color: Colors.white,
                      child: TextField(
                        controller: customerOpeningBalance,
                        onChanged: (value){
                          customerBalance=value;
                        },
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black38, width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38, width: 1.0),
                            ),
                            labelText: 'Opening Balance',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 30.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black38,
                            style: BorderStyle.solid,
                            width: 0.80),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value:selectedPrice.trim() , // Not necessary for Option 1
                          items: priceList.map((String val) {
                            return DropdownMenuItem(
                              child: new Text(val.toString()),
                              value: val,
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedPrice = newValue.toString();
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 30.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black38,
                            style: BorderStyle.solid,
                            width: 0.80),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value:selectedcurrentroute.trim() , // Not necessary for Option 1
                          items: currentroutes.map((String val) {
                            return DropdownMenuItem(
                              child: new Text(val.toString()),
                              value: val,
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                             selectedcurrentroute = newValue.toString();
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    TextButton(onPressed: ()async{
                      if(customerName==''|| address=='' || mobile==''){
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Error"),
                              content: Text("Fill all the fields"),
                              actions: <Widget>[
                                // usually buttons at the bottom of the dialog
                                new TextButton(
                                  child: new Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            )
                        );
                      }
                      else{
                        String inside='not';
                        for(int i=0;i<customerList.length;i++){
                          if(customerList[i].toLowerCase() == customerName.toLowerCase()){
                            inside='contains';
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Error"),
                                  content: Text("Customer name Exists"),
                                  actions: <Widget>[
                                    // usually buttons at the bottom of the dialog
                                    new TextButton(
                                      child: new Text("Close"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                )
                            );
                          }
                        }
                        if(inside == 'not'){
                          if(customerEdit.value==true){
                            firebaseFirestore
                                .collection('customer_details')
                                .doc(docId)
                                .set({
                              'customerName':customerName,
                              'address': address,
                              'mobile': mobile,
                              'vat': vat,
                              'priceList': selectedPrice,
                              'balance': customerBalance,
                              'flatNo': flatNoController.text,
                              'buildNo': buildNoController.text,
                              'roadNo':roadNoController.text,
                              'blockNo':blockNoController.text,
                              'area': areaNoController.text,
                              'landmark': landmarkNoController.text,
                              'note': customerNoteController.text,
                              'route':selectedcurrentroute.toString().trim()
                            }).then((_) {
                              print('success');
                            });
                            customerEdit.value=false;
                            docId='';
                          }
                          else{
                            String body='$customerName~$address~$mobile~$vat~$selectedPrice~$customerBalance~${flatNoController.text}~${buildNoController.text}~${roadNoController.text}~${blockNoController.text}~${areaNoController.text}~${landmarkNoController.text}~${customerNoteController.text}~$selectedcurrentroute';
                            create(body, 'customer_details');
                          }
                          customerName='';
                          address='';
                          mobile='';
                          vat='';
                          customerBalance='';
                          customerOpeningBalance.clear();
                          customerNameController.clear();
                          customerAddressController.clear();
                          customerMobileController.clear();
                          customerVatController.clear();
                          flatNoController.clear();
                          buildNoController.clear();
                          roadNoController.clear();
                          blockNoController.clear();
                          areaNoController.clear();
                          landmarkNoController.clear();
                          customerNoteController.clear();
                        }
                      }
                    }, child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: kBackgroundColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text('SUBMIT',
                        style: TextStyle(
                            letterSpacing: 1.5,
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                            color: Colors.white
                        ),
                      ),
                    ))
                  ],
                ),
              ) ,
            ),
          ),
          Expanded(
              child:Container(
                decoration:  BoxDecoration(
                    border: Border.all(color: kGreenColor)
                ),
                  child:StreamBuilder(
                    stream: firebaseFirestore
                        .collection('customer_details').orderBy('customerName',descending: false)
                        .snapshots(),
    builder: (BuildContext context,
    AsyncSnapshot<QuerySnapshot> snapshot) {
      List items=[];
      List id=[];
      if (!snapshot.hasData) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      return Column(
        children:[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: TextStyle(
                fontSize: MediaQuery.of(context).textScaleFactor*14,
              ),
              focusNode: nameNode,
              controller: customerVendorSearchController,
              decoration: new InputDecoration(
                  suffixIcon: IconButton(onPressed: () {
                    setState(() {
                      customerVendorSearchController.clear();
                    });
                    // searchResultItemSearch.clear();
                  },
                      icon: Icon(Icons.clear,color: Colors.black,)),
                  // suffixIconColor: kBlack,
                  border: OutlineInputBorder(),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:Colors.black, width: 2.0
                    ),
                    // borderRadius:  BorderRadius.all(Radius.circular(32.0),)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:Colors.black, width: 2.0
                    ),
                    // borderRadius:  BorderRadius.all(Radius.circular(32.0),)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:Colors.black, width: 2.0
                    ),
                    // borderRadius:  BorderRadius.all(Radius.circular(32.0),)
                  ),
                  hintText: 'search for customer'
              ),
              onChanged: (val){
                searchCustomerVendor(val,'customer');
              },
            ),
          ),
          Expanded(
            child: Obx(()=>Visibility(
                visible: searchResultCustomerVendor.isEmpty,
                replacement: Container(
                  // width: MediaQuery.of(context).size.width/3,
                    color: kItemContainer,
                    child:  Obx(()=> ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchResultCustomerVendor.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                          child: TextButton(
                            onPressed: () async {
                              DocumentSnapshot document=await firebaseFirestore.collection('customer_details').doc(id[items.indexOf(searchResultCustomerVendor[index])]).get();
                              docId=document.id;
                              customerName=customerNameController.text=document['customerName'];
                              address= customerAddressController.text=document['address'];
                              mobile= customerMobileController.text=document['mobile'];
                              customerBalance= customerOpeningBalance.text=document['balance'];
                              vat=customerVatController.text=document['vat'];
                              flatNoController.text=document['flatNo'];
                              buildNoController.text=document['buildNo'];
                              roadNoController.text=document['roadNo'];
                              blockNoController.text=document['blockNo'];
                              areaNoController.text=document['area'];
                              landmarkNoController.text=document['landmark'];
                              customerNoteController.text=document['note'];
                              selectedPrice=document['priceList'];
                              customerEdit.value=true;
                              searchResultCustomerVendor.clear();
                              customerVendorSearchController.clear();
                              FocusScope.of(context).unfocus();
                            },
                            child:Text(searchResultCustomerVendor[index].toString().replaceAll('#', '/'), style: TextStyle(
                                fontSize:
                                MediaQuery.of(context).textScaleFactor *
                                    15,
                                color: kBlack
                            ),),

                          ),
                        );
                      },
                    ))
                ),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: snapshot.data.docs.map((document) {
                    items.add(document['customerName']);
                    id.add(document.id);
                    return Padding(
                      padding:
                      const EdgeInsets.only(top: 4.0, bottom: 4.0),
                      child: TextButton(
                          onPressed: () async {
                            docId=document.id;
                            customerName=customerNameController.text=document['customerName'];
                            address= customerAddressController.text=document['address'];
                            mobile= customerMobileController.text=document['mobile'];
                            customerBalance= customerOpeningBalance.text=document['balance'];
                            vat=customerVatController.text=document['vat'];
                            flatNoController.text=document['flatNo'];
                            buildNoController.text=document['buildNo'];
                            roadNoController.text=document['roadNo'];
                            blockNoController.text=document['blockNo'];
                            areaNoController.text=document['area'];
                            landmarkNoController.text=document['landmark'];
                            customerNoteController.text=document['note'];
                            selectedPrice=document['priceList'];
                            customerEdit.value=true;
                          },
                          child: Text(
                            document['customerName'],
                            style: TextStyle(
                                fontSize:
                                MediaQuery.of(context).textScaleFactor *
                                    15,
                                color: kBlack
                            ),
                          )),
                    );
                  }).toList(),
                )
            )),

          ),
        ]
      );
    }
                  )
              )
          )
        ],
      );
    }
    else if(index==8){
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex:2,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child:Container(
                padding: EdgeInsets.all(50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vendor',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: MediaQuery.of(context).textScaleFactor * 40,
                        color: kBackgroundColor,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 30.0,
                      color: Colors.white,
                      child:  TextField(
                        controller: vendorNameController,
                        onChanged: (value){
                          vendorName=value;
                        },
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black38, width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38, width: 1.0),
                            ),
                            labelText: 'Vendor Name',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      // height: 100.0,
                      color: Colors.white,
                      child: TextField(
                        maxLines: 5,
                        controller: vendorAddressController,
                        onChanged: (value){
                          vendorAddress=value;
                        },
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black38, width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38, width: 1.0),
                            ),
                            labelText: 'Address',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 30.0,
                      color: Colors.white,
                      child: TextField(
                        controller: vendorMobileController,
                        onChanged: (value){
                          vendorMobile=value;
                        },
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black38, width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38, width: 1.0),
                            ),
                            labelText: 'Mobile Number',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 30.0,
                      color: Colors.white,
                      child: TextField(
                        controller: vendorVatController,
                        onChanged: (value){
                          vendorVat=value;
                        },
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black38, width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38, width: 1.0),
                            ),
                            labelText: 'VAT/GST NO',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 30.0,
                      color: Colors.white,
                      child: TextField(
                        controller: vendorOpeningBalance,
                        onChanged: (value){
                          vendorBalance=value;
                        },
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black38, width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38, width: 1.0),
                            ),
                            labelText: 'Opening Balance',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 30.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black38,
                            style: BorderStyle.solid,
                            width: 0.80),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value:selectedVendorPrice.trim() , // Not necessary for Option 1
                          items: priceList.map((String val) {
                            return DropdownMenuItem(
                              child: new Text(val.toString()),
                              value: val,
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedVendorPrice = newValue.toString();
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    TextButton(onPressed: ()async{
                      if(vendorName==''|| vendorAddress=='' || vendorMobile=='' ||vendorVat==''){
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Error"),
                              content: Text("Fill all the fields"),
                              actions: <Widget>[
                                // usually buttons at the bottom of the dialog
                                new TextButton(
                                  child: new Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            )
                        );
                      }
                      else{
                        String inside='not';
                        for(int i=0;i<vendorList.length;i++){
                          if(vendorList[i].toLowerCase() == vendorName.toLowerCase()){
                            inside='contains';
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Error"),
                                  content: Text("Vendor name Exists"),
                                  actions: <Widget>[
                                    // usually buttons at the bottom of the dialog
                                    new TextButton(
                                      child: new Text("Close"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                )
                            );
                          }
                        }
                        if(inside=='not'){
                          if(customerEdit==true){
                            firebaseFirestore
                                .collection('vendor_data')
                                .doc(docId)
                                .update({
                              'vendorName': vendorName,
                              'address': vendorAddress,
                              'mobile': vendorMobile,
                              'vat': vendorVat,
                              'priceList':selectedVendorPrice,
                              'balance':vendorOpeningBalance.text,
                            }).then((_) {
                              print('success');
                            });
                            customerEdit.value=false;
                            docId='';
                          }
                          else{
                            String body='$vendorName~$vendorAddress~$vendorMobile~$vendorVat~$selectedVendorPrice~${vendorOpeningBalance.text}';
                            create(body,'vendor_data');
                          }
                          vendorAddress='';
                          vendorName='';
                          vendorVat='';
                          vendorBalance='';
                          vendorNameController.clear();
                          vendorAddressController.clear();
                          vendorMobileController.clear();
                          vendorVatController.clear();
                          vendorOpeningBalance.clear();
                        }
                      }
                    }, child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: kBackgroundColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text('SUBMIT',
                        style: TextStyle(
                            letterSpacing: 1.5,
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                            color: Colors.white
                        ),
                      ),
                    ))
                  ],
                ),
              ) ,
            ),
          ),
          Expanded(
            child:Container(
              decoration:  BoxDecoration(
                  border: Border.all(color: kGreenColor)
              ),
              child:StreamBuilder(
                stream: firebaseFirestore
                    .collection('vendor_data').orderBy('vendorName',descending: false)
                    .snapshots(),
    builder: (BuildContext context,
    AsyncSnapshot<QuerySnapshot> snapshot) {
      List items=[];
      List id=[];
      if (!snapshot.hasData) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      return Column(
        children:[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: TextStyle(
                fontSize: MediaQuery.of(context).textScaleFactor*14,
              ),
              focusNode: nameNode,
              controller: customerVendorSearchController,
              decoration: new InputDecoration(
                  suffixIcon: IconButton(onPressed: () {
                    setState(() {
                      customerVendorSearchController.clear();
                    });
                    // searchResultItemSearch.clear();
                  },
                      icon: Icon(Icons.clear,color: Colors.black,)),
                  // suffixIconColor: kBlack,
                  border: OutlineInputBorder(),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:Colors.black, width: 2.0
                    ),
                    // borderRadius:  BorderRadius.all(Radius.circular(32.0),)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:Colors.black, width: 2.0
                    ),
                    // borderRadius:  BorderRadius.all(Radius.circular(32.0),)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:Colors.black, width: 2.0
                    ),
                    // borderRadius:  BorderRadius.all(Radius.circular(32.0),)
                  ),
                  hintText: 'search for vendor'
              ),
              onChanged: (val){
                searchCustomerVendor(val,'vendor');
              },
            ),
          ),
          Expanded(
            child: Obx(()=>Visibility(
                visible: searchResultCustomerVendor.isEmpty,
                replacement: Container(
                  // width: MediaQuery.of(context).size.width/3,
                    color: kItemContainer,
                    child:  Obx(()=> ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchResultCustomerVendor.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                          child: TextButton(
                            onPressed: () async {
                              DocumentSnapshot document=await firebaseFirestore.collection('vendor_data').doc(id[items.indexOf(searchResultCustomerVendor[index])]).get();
                              docId=document.id;
                              vendorName=vendorNameController.text=document['vendorName'];
                              vendorAddress= vendorAddressController.text=document['address'];
                              vendorMobile= vendorMobileController.text=document['mobile'];
                              vendorOpeningBalance.text=document['balance'];
                              vendorVat=vendorVatController.text=document['vat'];
                              selectedVendorPrice=document['priceList'];
                              customerEdit.value=true;
                              searchResultCustomerVendor.clear();
                              customerVendorSearchController.clear();
                              FocusScope.of(context).unfocus();
                            },
                            child:Text(searchResultCustomerVendor[index].toString().replaceAll('#', '/'), style: TextStyle(
                                fontSize:
                                MediaQuery.of(context).textScaleFactor *
                                    15,
                                color: kBlack
                            ),),

                          ),
                        );
                      },
                    ))
                ),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: snapshot.data.docs.map((document) {
                    items.add(document['vendorName']);
                    id.add(document.id);
                    return Padding(
                      padding:
                      const EdgeInsets.only(top: 4.0, bottom: 4.0),
                      child: TextButton(
                          onPressed: () async {
                            docId=document.id;
                            vendorName=vendorNameController.text=document['vendorName'];
                            vendorAddress= vendorAddressController.text=document['address'];
                            vendorMobile= vendorMobileController.text=document['mobile'];
                            vendorOpeningBalance.text=document['balance'];
                            vendorVat=vendorVatController.text=document['vat'];
                            selectedVendorPrice=document['priceList'];
                            customerEdit.value=true;
                          },
                          child: Text(
                            document['vendorName'],
                            style: TextStyle(
                                fontSize:
                                MediaQuery.of(context).textScaleFactor *
                                    15,
                                color: kBlack
                            ),
                          )),
                    );
                  }).toList(),
                )
            )),

          ),
        ]
      );
    }
              )
            )
          )
        ],
      );
    }
    else if (index == 9) {
      return Container(
        padding: EdgeInsets.all(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Modifier Details',
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: MediaQuery.of(context).textScaleFactor * 40,
                color: kBackgroundColor,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextButton(
                onPressed: ()  {
                  modifierController.text='';
                  selectedModifierType='Topping';
                  modifierPriceController.text='';
                  selectedModifierCategory=[];
                  for(int i=0;i<allCategoryList.length;i++){
                    selectedModifierCategory.add(true);
                  }
                  showDialog(
                      context: context,
                      builder: (context) => StatefulBuilder(
                        builder: (context,setState){
                          return Dialog(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height/3.5,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Text('Name',style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                            ),),
                                            SizedBox(width: 20,),
                                            Container(
                                              width: MediaQuery.of(context).size.width / 4,
                                              //height: 30.0,
                                              color: Colors.white,
                                              child: TextField(
                                                controller: modifierController,
                                                decoration: InputDecoration(
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(color: Colors.black38, width: 1.0)),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.black38, width: 1.0),
                                                    ),
                                                    labelText: 'Modifier name',
                                                    labelStyle: TextStyle(
                                                      color: Colors.black38,
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20,),
                                        Row(
                                          children: [
                                            Text('Category',style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                            ),),
                                            SizedBox(width: 20,),
                                            Container(
                                                width: MediaQuery.of(context).size.width / 4,
                                                height: 30.0,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black38,
                                                      style: BorderStyle.solid,
                                                      width: 0.80),
                                                ),
                                                // child: DropdownButtonHideUnderline(
                                                //   child: DropdownButton(
                                                //     hint: Text('  Category List'),
                                                //     value: selectedCategory,
                                                //     items: allCategoryList.map((value) {
                                                //       return DropdownMenuItem(value: value, child: Text(value));
                                                //     }).toList(),
                                                //     onChanged: (newValue) {
                                                //       setState(() {
                                                //         selectedCategory = newValue.toString();
                                                //       });
                                                //     },
                                                //   ),
                                                // ),
                                                child:Center(
                                                  child: GestureDetector(
                                                    onTap: (){
                                                      showDialog(   context: context,
                                                          builder: (context) => StatefulBuilder(
                                                            builder: (context,setState){
                                                              return Dialog(

                                                                child: SizedBox(
                                                                  width: MediaQuery.of(context).size.width / 3,
                                                                  child: ListView.builder(
                                                                      itemCount: allCategoryList.length,
                                                                      itemBuilder: (context,index){
                                                                        return CheckboxListTile(
                                                                          title: Text(allCategoryList[index]),
                                                                          onChanged: (value) {
                                                                            print('value $value');
                                                                            setState(() {
                                                                              selectedModifierCategory[index]= !selectedModifierCategory[index];
                                                                            });
                                                                          }, value: selectedModifierCategory[index],
                                                                        );
                                                                      }
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          )
                                                      );
                                                    },
                                                    child: Text('Show Category',style:TextStyle( fontWeight: FontWeight.bold,)),
                                                  ),
                                                )
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Text('Type',style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                            ),),
                                            SizedBox(width: 20,),
                                            Container(
                                              width: MediaQuery.of(context).size.width / 4,
                                              height: 30.0,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black38,
                                                    style: BorderStyle.solid,
                                                    width: 0.80),
                                              ),
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton(
                                                  value: selectedModifierType,
                                                  items: modifierType.map((value) {
                                                    return DropdownMenuItem(value: value, child: Text(value));
                                                  }).toList(),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      selectedModifierType = newValue.toString();
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20,),
                                        Row(
                                          children: [
                                            Text('Price',style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                            ),),
                                            SizedBox(width: 20,),
                                            Container(
                                              width: MediaQuery.of(context).size.width / 4,
                                              //height: 30.0,
                                              color: Colors.white,
                                              child: TextField(
                                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),],
                                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                controller: modifierPriceController,
                                                decoration: InputDecoration(
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(color: Colors.black38, width: 1.0)),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.black38, width: 1.0),
                                                    ),
                                                    //labelText: 'Floor name',
                                                    labelStyle: TextStyle(
                                                      color: Colors.black38,
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),

                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                            onPressed: ()  {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'CANCEL',
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                                  color: Colors.white,
                                                  letterSpacing: 1.5,
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                color: kBackgroundColor,
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                            )),
                                        SizedBox(height:10),
                                        TextButton(
                                            onPressed: ()  {
                                              List categoryAdded=[];
                                              if(modifierPriceController.text.isEmpty || modifierController.text.isEmpty){
                                                showDialog(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                      title: Text("Error"),
                                                      content: Text("Fill all the fields"),
                                                      actions: <Widget>[
                                                        // usually buttons at the bottom of the dialog
                                                        new TextButton(
                                                          child: new Text("Close"),
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                        ),
                                                      ],
                                                    )
                                                );
                                              }
                                              else{
                                                for(int i=0;i<selectedModifierCategory.length;i++){
                                                  if(selectedModifierCategory[i]){
                                                    categoryAdded.add(allCategoryList[i]);
                                                  }
                                                }
                                                //  String body='${modifierController.text}~${modifierPriceController.text}~$selectedModifierType';
                                                firebaseFirestore
                                                    .collection("modifier_data")
                                                    .doc(modifierController.text)
                                                    .set({
                                                  'name':modifierController.text,
                                                  'price':modifierPriceController.text,
                                                  'type':selectedModifierType,
                                                  'category':categoryAdded,
                                                });
                                                // create(floorNameController.text, 'floor_data');
                                                modifierController.clear();
                                                modifierPriceController.clear();
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'CONFIRM',
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                                  color: Colors.white,
                                                  letterSpacing: 1.5,
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                color: kBackgroundColor,
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Add',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor * 20,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                )),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Topping',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).textScaleFactor * 15,
                              color: kBackgroundColor,
                            ),),
                            SizedBox(height:10),
                            StreamBuilder(
                                stream: firebaseFirestore.collection('modifier_data').where('type',isEqualTo:'Topping').snapshots(),
                                builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot3) {
                                  if (!snapshot3.hasData) {
                                    return Center(
                                      child: Text('Empty'),
                                    );
                                  }
                                  return GridView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio:
                                        MediaQuery.of(context).size.width /
                                            (MediaQuery.of(context).size.height ),
                                      ),
                                      scrollDirection: Axis.vertical,
                                      itemCount: snapshot3.data.docs.length,
                                      itemBuilder: (context, index8) {
                                        return   Padding(
                                          padding: const EdgeInsets.only(left: 6,right: 6,bottom: 6),
                                          child:   Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color:kBackgroundColor,
                                                  style: BorderStyle.solid,
                                                  width: 0.80),

                                            ),

                                            child: Stack(children: [

                                              Positioned.fill(child: Align(alignment: Alignment.center,child: Padding(
                                                padding: const EdgeInsets.only(bottom: 10.0),
                                                child: Text(snapshot3.data.docs[index8]['name'],style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: MediaQuery.of(context).textScaleFactor * 15,
                                                  color: kBackgroundColor,
                                                )),
                                              ))),
                                              Positioned.fill(child: Align(alignment: Alignment.bottomLeft,child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 8.0),
                                                    child: Text('''$symbol ${snapshot3.data.docs[index8]['price']}''',style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: MediaQuery.of(context).textScaleFactor * 15,
                                                      color: kBackgroundColor,
                                                    )),
                                                  ),
                                                  Row(children:[
                                                    IconButton(onPressed: (){
                                                      String modifierOldName=snapshot3.data.docs[index8]['name'];
                                                      modifierController.text=snapshot3.data.docs[index8]['name'];
                                                      selectedModifierType='Topping';
                                                      modifierPriceController.text=snapshot3.data.docs[index8]['price'];
                                                      selectedModifierCategory=[];
                                                      List temp=snapshot3.data.docs[index8]['category'];
                                                      for(int i=0;i<allCategoryList.length;i++){
                                                        if(temp.contains(allCategoryList[i])){
                                                          selectedModifierCategory.add(true);
                                                        }
                                                        else{
                                                          selectedModifierCategory.add(false);
                                                        }
                                                      }
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) => StatefulBuilder(
                                                            builder: (context,setState){
                                                              return Dialog(
                                                                child: SingleChildScrollView(
                                                                  scrollDirection: Axis.vertical,
                                                                  child: Container(
                                                                    padding: EdgeInsets.all(10.0),
                                                                    width: MediaQuery.of(context).size.width,
                                                                    height: MediaQuery.of(context).size.height/3.5,
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Text('Name',style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                                                                ),),
                                                                                SizedBox(width: 20,),
                                                                                Container(
                                                                                  width: MediaQuery.of(context).size.width / 4,
                                                                                  //height: 30.0,
                                                                                  color: Colors.white,
                                                                                  child: TextField(
                                                                                    controller: modifierController,
                                                                                    decoration: InputDecoration(
                                                                                        enabledBorder: OutlineInputBorder(
                                                                                            borderSide:
                                                                                            BorderSide(color: Colors.black38, width: 1.0)),
                                                                                        focusedBorder: OutlineInputBorder(
                                                                                          borderSide: BorderSide(color: Colors.black38, width: 1.0),
                                                                                        ),
                                                                                        labelText: 'Modifier name',
                                                                                        labelStyle: TextStyle(
                                                                                          color: Colors.black38,
                                                                                        )),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(height: 20,),
                                                                            Row(
                                                                              children: [
                                                                                Text('Category',style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                                                                ),),
                                                                                SizedBox(width: 20,),
                                                                                TextButton(
                                                                                  onPressed: (){
                                                                                    showDialog(   context: context,
                                                                                        builder: (context) => StatefulBuilder(
                                                                                          builder: (context,setState){
                                                                                            return Dialog(

                                                                                              child: SizedBox(
                                                                                                width: MediaQuery.of(context).size.width / 3,
                                                                                                child: ListView.builder(
                                                                                                    itemCount: allCategoryList.length,
                                                                                                    itemBuilder: (context,index){
                                                                                                      return CheckboxListTile(
                                                                                                        title: Text(allCategoryList[index]),
                                                                                                        onChanged: (value) {
                                                                                                          setState(() {
                                                                                                            selectedModifierCategory[index]= !selectedModifierCategory[index];
                                                                                                          });
                                                                                                        }, value: selectedModifierCategory[index],
                                                                                                      );
                                                                                                    }
                                                                                                ),
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                        )
                                                                                    );
                                                                                  },
                                                                                  child: Container(
                                                                                      width: MediaQuery.of(context).size.width / 4,
                                                                                      height: 30.0,
                                                                                      decoration: BoxDecoration(
                                                                                        border: Border.all(
                                                                                            color: Colors.black38,
                                                                                            style: BorderStyle.solid,
                                                                                            width: 0.80),
                                                                                      ),
                                                                                      child:Center(
                                                                                        child: Text('Show Category',style: TextStyle(
                                                                                          color: Colors.black,
                                                                                          fontWeight: FontWeight.bold,
                                                                                          fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                                                                        ),),
                                                                                      )
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Text('Type',style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                                                                ),),
                                                                                SizedBox(width: 20,),
                                                                                Container(
                                                                                  width: MediaQuery.of(context).size.width / 4,
                                                                                  height: 30.0,
                                                                                  decoration: BoxDecoration(
                                                                                    border: Border.all(
                                                                                        color: Colors.black38,
                                                                                        style: BorderStyle.solid,
                                                                                        width: 0.80),
                                                                                  ),
                                                                                  child: DropdownButtonHideUnderline(
                                                                                    child: DropdownButton(
                                                                                      value: selectedModifierType,
                                                                                      items: modifierType.map((value) {
                                                                                        return DropdownMenuItem(value: value, child: Text(value));
                                                                                      }).toList(),
                                                                                      onChanged: (newValue) {
                                                                                        setState(() {
                                                                                          selectedModifierType = newValue.toString();
                                                                                        });
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(height: 20,),
                                                                            Row(
                                                                              children: [
                                                                                Text('Price',style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                                                                ),),
                                                                                SizedBox(width: 20,),
                                                                                Container(
                                                                                  width: MediaQuery.of(context).size.width / 4,
                                                                                  //height: 30.0,
                                                                                  color: Colors.white,
                                                                                  child: TextField(
                                                                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),],
                                                                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                                    controller: modifierPriceController,
                                                                                    decoration: InputDecoration(
                                                                                        enabledBorder: OutlineInputBorder(
                                                                                            borderSide:
                                                                                            BorderSide(color: Colors.black38, width: 1.0)),
                                                                                        focusedBorder: OutlineInputBorder(
                                                                                          borderSide: BorderSide(color: Colors.black38, width: 1.0),
                                                                                        ),
                                                                                        //labelText: 'Floor name',
                                                                                        labelStyle: TextStyle(
                                                                                          color: Colors.black38,
                                                                                        )),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),

                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            TextButton(
                                                                                onPressed: ()  {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Container(
                                                                                  padding: EdgeInsets.all(8.0),
                                                                                  child: Text(
                                                                                    'CANCEL',
                                                                                    style: TextStyle(
                                                                                      fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                                                                      color: Colors.white,
                                                                                      letterSpacing: 1.5,
                                                                                    ),
                                                                                  ),
                                                                                  decoration: BoxDecoration(
                                                                                    color: kBackgroundColor,
                                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                                  ),
                                                                                )),
                                                                            SizedBox(height:10),
                                                                            TextButton(
                                                                                onPressed: ()  {
                                                                                  List categoryAdded=[];
                                                                                  if(modifierPriceController.text.isEmpty || modifierController.text.isEmpty){
                                                                                    showDialog(
                                                                                        context: context,
                                                                                        builder: (context) => AlertDialog(
                                                                                          title: Text("Error"),
                                                                                          content: Text("Fill all the fields"),
                                                                                          actions: <Widget>[
                                                                                            // usually buttons at the bottom of the dialog
                                                                                            new TextButton(
                                                                                              child: new Text("Close"),
                                                                                              onPressed: () {
                                                                                                Navigator.of(context).pop();
                                                                                              },
                                                                                            ),
                                                                                          ],
                                                                                        )
                                                                                    );
                                                                                  }
                                                                                  else{
                                                                                    for(int i=0;i<selectedModifierCategory.length;i++){
                                                                                      if(selectedModifierCategory[i]){
                                                                                        categoryAdded.add(allCategoryList[i]);
                                                                                      }
                                                                                    }
                                                                                    //  String body='${modifierController.text}~${modifierPriceController.text}~$selectedModifierType';
                                                                                    if(modifierOldName!=modifierController.text)
                                                                                    firebaseFirestore.collection("modifier_data").doc(modifierOldName).delete();
                                                                                    firebaseFirestore
                                                                                        .collection("modifier_data")
                                                                                        .doc(modifierController.text)
                                                                                        .set({
                                                                                      'name':modifierController.text,
                                                                                      'price':modifierPriceController.text,
                                                                                      'type':selectedModifierType,
                                                                                      'category':categoryAdded,
                                                                                    });
                                                                                    // create(floorNameController.text, 'floor_data');
                                                                                    modifierController.clear();
                                                                                    modifierPriceController.clear();
                                                                                    Navigator.pop(context);
                                                                                  }
                                                                                },
                                                                                child: Container(
                                                                                  padding: EdgeInsets.all(8.0),
                                                                                  child: Text(
                                                                                    'CONFIRM',
                                                                                    style: TextStyle(
                                                                                      fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                                                                      color: Colors.white,
                                                                                      letterSpacing: 1.5,
                                                                                    ),
                                                                                  ),
                                                                                  decoration: BoxDecoration(
                                                                                    color: kBackgroundColor,
                                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                                  ),
                                                                                )),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          )
                                                      );
                                                    },icon:Icon(Icons.edit),),
                                                    IconButton(onPressed: (){
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) => new AlertDialog(
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                                          title: new Text('Are you sure?'),
                                                          content: new Text('Delete ${snapshot3.data.docs[index8]['name']} Modifier'),
                                                          actions: <Widget>[
                                                            new TextButton(
                                                              onPressed: () => Navigator.of(context).pop(false),
                                                              child: Container(
                                                                  padding: EdgeInsets.all(6.0),
                                                                  width: 100,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius.circular(10.0),
                                                                      border: Border.all(color: kBlack)
                                                                  ),
                                                                  child: Center(
                                                                    child: Text("Cancel",style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.bold
                                                                    ),),
                                                                  )),
                                                            ),
                                                            SizedBox(height: 16),

                                                            new TextButton(
                                                              onPressed: ()  {
                                                                firebaseFirestore.collection('modifier_data').doc(snapshot3.data.docs[index8].id).delete();
                                                                Navigator.pop(context);
                                                              } ,
                                                              child: Container(
                                                                  padding: EdgeInsets.all(6.0),
                                                                  width: 100,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius.circular(10.0),
                                                                      border: Border.all(color: kBlack)
                                                                  ),
                                                                  child: Center(child: Text("Delete",style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.bold
                                                                  )))),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },icon:Icon(Icons.delete),),
                                                  ])
                                                ],
                                              ))),
                                            ],),
                                          ),
                                        );
                                      }
                                  );
                                }
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Flavour',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).textScaleFactor * 15,
                              color: kBackgroundColor,
                            ),),
                            SizedBox(height:10),
                            StreamBuilder(
                                stream: firebaseFirestore.collection('modifier_data').where('type',isEqualTo:'Flavour').snapshots(),
                                builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot3) {
                                  if (!snapshot3.hasData) {
                                    return Center(
                                      child: Text('Empty'),
                                    );
                                  }
                                  return GridView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio:
                                        MediaQuery.of(context).size.width /
                                            (MediaQuery.of(context).size.height ),
                                      ),
                                      scrollDirection: Axis.vertical,
                                      itemCount: snapshot3.data.docs.length,
                                      itemBuilder: (context, index8) {
                                        return   Padding(
                                          padding: const EdgeInsets.only(left: 6,right: 6,bottom: 6),
                                          child:   Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color:kBackgroundColor,
                                                  style: BorderStyle.solid,
                                                  width: 0.80),

                                            ),

                                            child: Stack(children: [

                                              Positioned.fill(child: Align(alignment: Alignment.center,child: Padding(
                                                padding: const EdgeInsets.only(bottom:10.0),
                                                child: Text(snapshot3.data.docs[index8]['name'],style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: MediaQuery.of(context).textScaleFactor * 15,
                                                  color: kBackgroundColor,
                                                )),
                                              ))),

                                              Positioned.fill(child: Align(alignment: Alignment.bottomLeft,child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 8.0),
                                                    child: Text('''$symbol ${snapshot3.data.docs[index8]['price']}''',style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: MediaQuery.of(context).textScaleFactor * 15,
                                                      color: kBackgroundColor,
                                                    )),
                                                  ),
                                                  Row(children:[
                                                    IconButton(onPressed: (){
                                                      String modifierOldName=snapshot3.data.docs[index8]['name'];
                                                      modifierController.text=snapshot3.data.docs[index8]['name'];
                                                      selectedModifierType='Flavour';
                                                      modifierPriceController.text=snapshot3.data.docs[index8]['price'];
                                                      selectedModifierCategory=[];
                                                      List temp=snapshot3.data.docs[index8]['category'];
                                                      for(int i=0;i<allCategoryList.length;i++){
                                                        if(temp.contains(allCategoryList[i])){
                                                          selectedModifierCategory.add(true);
                                                        }
                                                        else{
                                                          selectedModifierCategory.add(false);
                                                        }
                                                      }
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) => StatefulBuilder(
                                                            builder: (context,setState){
                                                              return Dialog(
                                                                child: SingleChildScrollView(
                                                                  scrollDirection: Axis.vertical,
                                                                  child: Container(
                                                                    padding: EdgeInsets.all(10.0),
                                                                    width: MediaQuery.of(context).size.width,
                                                                    height: MediaQuery.of(context).size.height/3.5,
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Text('Name',style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                                                                ),),
                                                                                SizedBox(width: 20,),
                                                                                Container(
                                                                                  width: MediaQuery.of(context).size.width / 4,
                                                                                  //height: 30.0,
                                                                                  color: Colors.white,
                                                                                  child: TextField(
                                                                                    controller: modifierController,
                                                                                    decoration: InputDecoration(
                                                                                        enabledBorder: OutlineInputBorder(
                                                                                            borderSide:
                                                                                            BorderSide(color: Colors.black38, width: 1.0)),
                                                                                        focusedBorder: OutlineInputBorder(
                                                                                          borderSide: BorderSide(color: Colors.black38, width: 1.0),
                                                                                        ),
                                                                                        labelText: 'Modifier name',
                                                                                        labelStyle: TextStyle(
                                                                                          color: Colors.black38,
                                                                                        )),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(height: 20,),
                                                                            Row(
                                                                              children: [
                                                                                Text('Category',style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                                                                ),),
                                                                                SizedBox(width: 20,),
                                                                                TextButton(
                                                                                  onPressed: (){
                                                                                    showDialog(   context: context,
                                                                                        builder: (context) => StatefulBuilder(
                                                                                          builder: (context,setState){
                                                                                            return Dialog(

                                                                                              child: SizedBox(
                                                                                                width: MediaQuery.of(context).size.width / 3,
                                                                                                child: ListView.builder(
                                                                                                    itemCount: allCategoryList.length,
                                                                                                    itemBuilder: (context,index){
                                                                                                      return CheckboxListTile(
                                                                                                        title: Text(allCategoryList[index]),
                                                                                                        onChanged: (value) {
                                                                                                          setState(() {
                                                                                                            selectedModifierCategory[index]= !selectedModifierCategory[index];
                                                                                                          });
                                                                                                        }, value: selectedModifierCategory[index],
                                                                                                      );
                                                                                                    }
                                                                                                ),
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                        )
                                                                                    );
                                                                                  },
                                                                                  child: Container(
                                                                                      width: MediaQuery.of(context).size.width / 4,
                                                                                      height: 30.0,
                                                                                      decoration: BoxDecoration(
                                                                                        border: Border.all(
                                                                                            color: Colors.black38,
                                                                                            style: BorderStyle.solid,
                                                                                            width: 0.80),
                                                                                      ),
                                                                                      child:Center(
                                                                                        child: Text('Show Category',style: TextStyle(
                                                                                          color: Colors.black,
                                                                                          fontWeight: FontWeight.bold,
                                                                                          fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                                                                        ),),
                                                                                      )
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Text('Type',style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                                                                ),),
                                                                                SizedBox(width: 20,),
                                                                                Container(
                                                                                  width: MediaQuery.of(context).size.width / 4,
                                                                                  height: 30.0,
                                                                                  decoration: BoxDecoration(
                                                                                    border: Border.all(
                                                                                        color: Colors.black38,
                                                                                        style: BorderStyle.solid,
                                                                                        width: 0.80),
                                                                                  ),
                                                                                  child: DropdownButtonHideUnderline(
                                                                                    child: DropdownButton(
                                                                                      value: selectedModifierType,
                                                                                      items: modifierType.map((value) {
                                                                                        return DropdownMenuItem(value: value, child: Text(value));
                                                                                      }).toList(),
                                                                                      onChanged: (newValue) {
                                                                                        setState(() {
                                                                                          selectedModifierType = newValue.toString();
                                                                                        });
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(height: 20,),
                                                                            Row(
                                                                              children: [
                                                                                Text('Price',style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                                                                ),),
                                                                                SizedBox(width: 20,),
                                                                                Container(
                                                                                  width: MediaQuery.of(context).size.width / 4,
                                                                                  //height: 30.0,
                                                                                  color: Colors.white,
                                                                                  child: TextField(
                                                                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),],
                                                                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                                    controller: modifierPriceController,
                                                                                    decoration: InputDecoration(
                                                                                        enabledBorder: OutlineInputBorder(
                                                                                            borderSide:
                                                                                            BorderSide(color: Colors.black38, width: 1.0)),
                                                                                        focusedBorder: OutlineInputBorder(
                                                                                          borderSide: BorderSide(color: Colors.black38, width: 1.0),
                                                                                        ),
                                                                                        //labelText: 'Floor name',
                                                                                        labelStyle: TextStyle(
                                                                                          color: Colors.black38,
                                                                                        )),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),

                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            TextButton(
                                                                                onPressed: ()  {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Container(
                                                                                  padding: EdgeInsets.all(8.0),
                                                                                  child: Text(
                                                                                    'CANCEL',
                                                                                    style: TextStyle(
                                                                                      fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                                                                      color: Colors.white,
                                                                                      letterSpacing: 1.5,
                                                                                    ),
                                                                                  ),
                                                                                  decoration: BoxDecoration(
                                                                                    color: kBackgroundColor,
                                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                                  ),
                                                                                )),
                                                                            SizedBox(height:10),
                                                                            TextButton(
                                                                                onPressed: ()  {
                                                                                  List categoryAdded=[];
                                                                                  if(modifierPriceController.text.isEmpty || modifierController.text.isEmpty){
                                                                                    showDialog(
                                                                                        context: context,
                                                                                        builder: (context) => AlertDialog(
                                                                                          title: Text("Error"),
                                                                                          content: Text("Fill all the fields"),
                                                                                          actions: <Widget>[
                                                                                            // usually buttons at the bottom of the dialog
                                                                                            new TextButton(
                                                                                              child: new Text("Close"),
                                                                                              onPressed: () {
                                                                                                Navigator.of(context).pop();
                                                                                              },
                                                                                            ),
                                                                                          ],
                                                                                        )
                                                                                    );
                                                                                  }
                                                                                  else{
                                                                                    for(int i=0;i<selectedModifierCategory.length;i++){
                                                                                      if(selectedModifierCategory[i]){
                                                                                        categoryAdded.add(allCategoryList[i]);
                                                                                      }
                                                                                    }
                                                                                    //  String body='${modifierController.text}~${modifierPriceController.text}~$selectedModifierType';
                                                                                    if(modifierOldName!=modifierController.text)
                                                                                      firebaseFirestore.collection("modifier_data").doc(modifierOldName).delete();
                                                                                    firebaseFirestore
                                                                                        .collection("modifier_data")
                                                                                        .doc(modifierController.text)
                                                                                        .set({
                                                                                      'name':modifierController.text,
                                                                                      'price':modifierPriceController.text,
                                                                                      'type':selectedModifierType,
                                                                                      'category':categoryAdded,
                                                                                    });
                                                                                    // create(floorNameController.text, 'floor_data');
                                                                                    modifierController.clear();
                                                                                    modifierPriceController.clear();
                                                                                    Navigator.pop(context);
                                                                                  }
                                                                                },
                                                                                child: Container(
                                                                                  padding: EdgeInsets.all(8.0),
                                                                                  child: Text(
                                                                                    'CONFIRM',
                                                                                    style: TextStyle(
                                                                                      fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                                                                      color: Colors.white,
                                                                                      letterSpacing: 1.5,
                                                                                    ),
                                                                                  ),
                                                                                  decoration: BoxDecoration(
                                                                                    color: kBackgroundColor,
                                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                                  ),
                                                                                )),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          )
                                                      );
                                                    },icon:Icon(Icons.edit),),
                                                    IconButton(onPressed: (){
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) => new AlertDialog(
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                                          title: new Text('Are you sure?'),
                                                          content: new Text('Delete ${snapshot3.data.docs[index8]['name']} Modifier'),
                                                          actions: <Widget>[
                                                            new TextButton(
                                                              onPressed: () => Navigator.of(context).pop(false),
                                                              child: Container(
                                                                  padding: EdgeInsets.all(6.0),
                                                                  width: 100,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius.circular(10.0),
                                                                      border: Border.all(color: kBlack)
                                                                  ),
                                                                  child: Center(
                                                                    child: Text("Cancel",style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.bold
                                                                    ),),
                                                                  )),
                                                            ),
                                                            SizedBox(height: 16),

                                                            new TextButton(
                                                              onPressed: ()  {
                                                                firebaseFirestore.collection('modifier_data').doc(snapshot3.data.docs[index8].id).delete();
                                                                Navigator.pop(context);
                                                              } ,
                                                              child: Container(
                                                                  padding: EdgeInsets.all(6.0),
                                                                  width: 100,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius.circular(10.0),
                                                                      border: Border.all(color: kBlack)
                                                                  ),
                                                                  child: Center(child: Text("Delete",style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.bold
                                                                  )))),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },icon:Icon(Icons.delete),),
                                                  ])
                                                ],
                                              ))),



                                            ],),



                                          ),
                                        );
                                      }
                                  );
                                }
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(4.0),
                  //     child: SingleChildScrollView(
                  //       scrollDirection: Axis.vertical,
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text('Promotion',style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: MediaQuery.of(context).textScaleFactor * 15,
                  //             color: kBackgroundColor,
                  //           ),),
                  //           SizedBox(height:10),
                  //           StreamBuilder(
                  //               stream: firebaseFirestore.collection('modifier_data').where('type',whereIn:['Reduce','Discount']).snapshots(),
                  //               builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot3) {
                  //                 if (!snapshot3.hasData) {
                  //                   return Center(
                  //                     child: Text('Empty'),
                  //                   );
                  //                 }
                  //                 return GridView.builder(
                  //                     physics: NeverScrollableScrollPhysics(),
                  //                     shrinkWrap: true,
                  //                     gridDelegate:
                  //                     SliverGridDelegateWithFixedCrossAxisCount(
                  //                       crossAxisCount: 2,
                  //                       childAspectRatio:
                  //                       MediaQuery.of(context).size.width /
                  //                           (MediaQuery.of(context).size.height ),
                  //                     ),
                  //                     scrollDirection: Axis.vertical,
                  //                     itemCount: snapshot3.data.docs.length,
                  //                     itemBuilder: (context, index8) {
                  //                       return   Padding(
                  //                         padding: const EdgeInsets.only(left: 6,right: 6,bottom: 6),
                  //                         child:   Container(
                  //                           decoration: BoxDecoration(
                  //                             border: Border.all(
                  //                                 color:kBackgroundColor,
                  //                                 style: BorderStyle.solid,
                  //                                 width: 0.80),
                  //
                  //                           ),
                  //
                  //                           child: Stack(children: [
                  //
                  //                             Positioned.fill(child: Align(alignment: Alignment.center,child: Padding(
                  //                               padding: const EdgeInsets.only(bottom: 10.0),
                  //                               child: Text(snapshot3.data.docs[index8]['name'],style: TextStyle(
                  //                                 fontWeight: FontWeight.bold,
                  //                                 fontSize: MediaQuery.of(context).textScaleFactor * 15,
                  //                                 color: kBackgroundColor,
                  //                               )),
                  //                             ))),
                  //                             Positioned.fill(child: Align(alignment: Alignment.bottomLeft,child: Row(
                  //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                               children: [
                  //                                 Padding(
                  //                                   padding: const EdgeInsets.only(left: 8.0),
                  //                                   child: Text('''$symbol ${snapshot3.data.docs[index8]['price']}''',style: TextStyle(
                  //                                     fontWeight: FontWeight.bold,
                  //                                     fontSize: MediaQuery.of(context).textScaleFactor * 15,
                  //                                     color: kBackgroundColor,
                  //                                   )),
                  //                                 ),
                  //                                 Row(children:[
                  //                                   IconButton(onPressed: (){
                  //
                  //                                   },icon:Icon(Icons.edit),),
                  //                                   IconButton(onPressed: (){
                  //                                     showDialog(
                  //                                       context: context,
                  //                                       builder: (context) => new AlertDialog(
                  //                                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  //                                         title: new Text('Are you sure?'),
                  //                                         content: new Text('Delete ${snapshot3.data.docs[index8]['name']} Modifier'),
                  //                                         actions: <Widget>[
                  //                                           new TextButton(
                  //                                             onPressed: () => Navigator.of(context).pop(false),
                  //                                             child: Container(
                  //                                                 padding: EdgeInsets.all(6.0),
                  //                                                 width: 100,
                  //                                                 decoration: BoxDecoration(
                  //                                                     borderRadius:
                  //                                                     BorderRadius.circular(10.0),
                  //                                                     border: Border.all(color: kBlack)
                  //                                                 ),
                  //                                                 child: Center(
                  //                                                   child: Text("Cancel",style: TextStyle(
                  //                                                       color: Colors.black,
                  //                                                       fontWeight: FontWeight.bold
                  //                                                   ),),
                  //                                                 )),
                  //                                           ),
                  //                                           SizedBox(height: 16),
                  //
                  //                                           new TextButton(
                  //                                             onPressed: ()  {
                  //                                               firebaseFirestore.collection('modifier_data').doc(snapshot3.data.docs[index8].id).delete();
                  //                                               Navigator.pop(context);
                  //                                             } ,
                  //                                             child: Container(
                  //                                                 padding: EdgeInsets.all(6.0),
                  //                                                 width: 100,
                  //                                                 decoration: BoxDecoration(
                  //                                                     borderRadius:
                  //                                                     BorderRadius.circular(10.0),
                  //                                                     border: Border.all(color: kBlack)
                  //                                                 ),
                  //                                                 child: Center(child: Text("Delete",style: TextStyle(
                  //                                                     color: Colors.black,
                  //                                                     fontWeight: FontWeight.bold
                  //                                                 )))),
                  //                                           ),
                  //                                         ],
                  //                                       ),
                  //                                     );
                  //                                   },icon:Icon(Icons.delete),),
                  //                                 ])
                  //                               ],
                  //                             ))),
                  //
                  //
                  //
                  //                           ],),
                  //
                  //
                  //
                  //                         ),
                  //                       );
                  //                     }
                  //                 );
                  //               }
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            )
          ],
        ),
      );
    }
    else if(index==10){
      print('kotCategory $kotCategory');
      print('allCategoryList $allCategoryList');
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.all(25.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Printer Details',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: MediaQuery.of(context).textScaleFactor * 40,
                          color: kBackgroundColor,
                        ),
                      ),

                      SizedBox(
                        height: 30,
                      ),
                      Container(
                       // width: MediaQuery.of(context).size.width/4,
                        height: MediaQuery.of(context).size.height/4,
                        child: StreamBuilder(
                            stream: firebaseFirestore.collection('printer_data').snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                              if (!snapshot2.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return ListView(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                children: snapshot2.data.docs.map((document)  {
                                  return ListTile(
                                    leading: Icon(Icons.print,color: kBlack,),
                                    title: Text(document['printerName'],),
                                    subtitle: Column(
                                      children: [
                                        Text(document['type']),
                                        Text(document['ip']),
                                        Text(document['port']),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete,color: kBlack,), onPressed: () {
                                      firebaseFirestore.collection('printer_data').doc(document['printerName']).delete();
                                    },
                                    ),
                                  );
                                }).toList(),
                              );
                            }),
                      ),
                      MaterialButton(
                        onPressed: () {
                          //  editPrinter=false;
                          // printerType=='Network';
                          // isSelectedPrinter= [true,false];
                          bluetoothNameController.clear();
                          ipAddressEditController.clear();
                          printerNameEditController1.clear();
                          portNumberEditController1.clear();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return Dialog(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Container(
                                          padding: EdgeInsets.all(8.0),
                                          height:
                                          MediaQuery.of(context).size.height /1.5,
                                          width: MediaQuery.of(context).size.width/2 ,
                                          child: Stack(
                                            children: [

                                              Column(
                                                children: [
                                                  Align(
                                                    alignment:Alignment.topCenter,
                                                    child: ToggleButtons(
                                                      isSelected: isSelectedPrinter,
                                                      color:kGreenColor ,
                                                      borderColor: kGreenColor,
                                                      fillColor: kGreenColor,
                                                      borderWidth: 2,
                                                      selectedColor: kFont1Color,
                                                      selectedBorderColor: kFont3Color,
                                                      borderRadius: BorderRadius.circular(0),
                                                      children: <Widget>[
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Text(
                                                            'Network',
                                                            style: TextStyle( fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Text(
                                                            'Bluetooth',
                                                            style: TextStyle( fontSize: MediaQuery.of(context).textScaleFactor*20, ),
                                                          ),
                                                        ),
                                                      ],
                                                      onPressed: (int index8) {
                                                        setState(() {
                                                          for (int i = 0; i < isSelectedPrinter.length; i++) {
                                                            isSelectedPrinter[i] = i == index8;
                                                          }
                                                          print('indexxx $index8');
                                                          printerType=index8==0?'Network':'Bluetooth';
                                                          // selectedDeliveryKot=deliveryModeKot[index8];
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                if(printerType=='Network') Flex(
                                                    direction: Axis.vertical,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Printer Name',
                                                        style: TextStyle(
                                                          fontSize: MediaQuery.of(context).textScaleFactor * 18,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width / 4,
                                                        child: TextField(
                                                          controller: printerNameEditController1,
                                                          keyboardType: TextInputType.text,
                                                          cursorColor: kBackgroundColor,
                                                          decoration: InputDecoration(
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide:
                                                                BorderSide(color: kBackgroundColor, width: 2.0)),
                                                            enabledBorder: OutlineInputBorder(
                                                                borderSide:
                                                                BorderSide(color: kBackgroundColor, width: 2.0)),
                                                          ),
                                                          style: TextStyle(
                                                            fontSize: MediaQuery.of(context).textScaleFactor * 18,
                                                          ),
                                                          autofocus: true,
                                                          enabled: !editPrinter,
                                                          onChanged: (value) {
                                                            printerName = value;
                                                          },
                                                        ),
                                                      ),
                                                      Text(
                                                        'IP Address',
                                                        style: TextStyle(
                                                          fontSize: MediaQuery.of(context).textScaleFactor * 18,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width / 4,
                                                        child: TextField(
                                                          controller: ipAddressEditController,
                                                          keyboardType: TextInputType.number,
                                                          cursorColor: kBackgroundColor,
                                                          decoration: InputDecoration(
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide:
                                                                BorderSide(color: kBackgroundColor, width: 2.0)),
                                                            enabledBorder: OutlineInputBorder(
                                                                borderSide:
                                                                BorderSide(color: kBackgroundColor, width: 2.0)),
                                                          ),
                                                          style: TextStyle(
                                                            fontSize: MediaQuery.of(context).textScaleFactor * 18,
                                                          ),
                                                          autofocus: true,
                                                          onChanged: (value) {
                                                            ipAddress = value;
                                                          },
                                                        ),
                                                      ),
                                                      Text(
                                                        'Port Number',
                                                        style: TextStyle(
                                                          fontSize: MediaQuery.of(context).textScaleFactor * 18,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width / 4,
                                                        child: TextField(
                                                          controller: portNumberEditController1,
                                                          keyboardType: TextInputType.number,
                                                          cursorColor: kBackgroundColor,
                                                          decoration: InputDecoration(
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide:
                                                                BorderSide(color: kBackgroundColor, width: 2.0)),
                                                            enabledBorder: OutlineInputBorder(
                                                                borderSide:
                                                                BorderSide(color: kBackgroundColor, width: 2.0)),
                                                          ),
                                                          style: TextStyle(
                                                            fontSize: MediaQuery.of(context).textScaleFactor * 18,
                                                          ),
                                                          autofocus: true,
                                                          onChanged: (value) {
                                                            portNumber = value;
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  if(printerType=='Bluetooth') Expanded(
                                                    child: Column(
                                                      children: [
                                                        MaterialButton(
                                                          onPressed: (){
                                                            _startScanDevices();
                                                          },
                                                          color: kLightBlueColor,
                                                          child: Padding(
                                                            padding: EdgeInsets.all(8.0),
                                                            child: Text('SCAN',style: TextStyle(color: kItemContainer),),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            child: Obx(()=>ListView.builder(
                                                              scrollDirection: Axis.vertical,
                                                                shrinkWrap: true,
                                                                itemCount: _devices.value.length,
                                                                itemBuilder: (BuildContext context, int index) {
                                                                  return InkWell(
                                                                    onTap: () {
                                                                      selectedPrinter=_devices.value[index];
                                                                      print('printer detailsss');
                                                                      print(selectedPrinter.name);
                                                                      print(selectedPrinter.address);
                                                                  showDialog(context: context,
                                                                  builder: (BuildContext context){
                                                                    return Dialog(
                                                                      child: SingleChildScrollView(
                                                                        child: Column(
                                                                          children: [
                                                                            Text(
                                                                              'Printer Name',
                                                                              style: TextStyle(
                                                                                fontSize: MediaQuery.of(context).textScaleFactor * 18,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: MediaQuery.of(context).size.width / 4,
                                                                              child: TextField(
                                                                                controller: bluetoothNameController,
                                                                                keyboardType: TextInputType.text,
                                                                                cursorColor: kBackgroundColor,
                                                                                decoration: InputDecoration(
                                                                                  focusedBorder: OutlineInputBorder(
                                                                                      borderSide:
                                                                                      BorderSide(color: kBackgroundColor, width: 2.0)),
                                                                                  enabledBorder: OutlineInputBorder(
                                                                                      borderSide:
                                                                                      BorderSide(color: kBackgroundColor, width: 2.0)),
                                                                                ),
                                                                                style: TextStyle(
                                                                                  fontSize: MediaQuery.of(context).textScaleFactor * 18,
                                                                                ),
                                                                                autofocus: true,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              'Address',
                                                                              style: TextStyle(
                                                                                fontSize: MediaQuery.of(context).textScaleFactor * 18,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              selectedPrinter.address,
                                                                              style: TextStyle(
                                                                                fontSize: MediaQuery.of(context).textScaleFactor * 18,
                                                                              ),
                                                                            ),
                                                                            TextButton(
                                                                                onPressed: () async {
                                                                                  String temp;
                                                                                  temp =
                                                                                  '${bluetoothNameController.text}~${selectedPrinter.address}~~${allPrinter.isEmpty ? 'true' : 'false'}~Bluetooth';
                                                                                  create(temp, 'printer_data');
                                                                                  allPrinter.add(printerName);
                                                                                  print('allPrinter $allPrinter');
                                                                                  if(allPrinter.isEmpty){
                                                                                    defaultPrinter =bluetoothNameController.text ;
                                                                                    defaultIpAddress =selectedPrinter.address;
                                                                                    defaultPort = '';
                                                                                  }

                                                                                  Navigator.pop(context);
                                                                                  Navigator.pop(context);
                                                                                  setState((){
                                                                                    index=10;
                                                                                  });
                                                                                },
                                                                                child: Container(
                                                                                  padding: EdgeInsets.all(8.0),
                                                                                  color: kBackgroundColor,
                                                                                  child: Text(
                                                                                    'SAVE',
                                                                                    style: TextStyle(
                                                                                      letterSpacing: 1.5,
                                                                                      fontSize: MediaQuery.of(
                                                                                          context)
                                                                                          .textScaleFactor *
                                                                                          20,
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                  ),
                                                                                ))
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                  );
                                                                    },
                                                                    child: Column(
                                                                      children: <Widget>[
                                                                        Container(
                                                                          height: 60,
                                                                          padding: EdgeInsets.only(left: 10),
                                                                          alignment: Alignment.centerLeft,
                                                                          child: Row(
                                                                            children: <Widget>[
                                                                              Icon(Icons.print),
                                                                              SizedBox(width: 10),
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: <Widget>[
                                                                                  Text(_devices.value[index].name ?? ''),
                                                                                  Text(_devices.value[index].address),
                                                                                ],
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Divider(),
                                                                      ],
                                                                    ),
                                                                  );
                                                                })),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if(printerType=='Network')  Positioned.fill(
                                                child: Align(
                                                  alignment: Alignment.bottomRight,
                                                  child: TextButton(
                                                      onPressed: () async {
                                                        String temp;
                                                        temp =
                                                        '$printerName~$ipAddress~$portNumber~${allPrinter.isEmpty ? 'true' : 'false'}~Network';
                                                        create(temp, 'printer_data');
                                                        allPrinter.add(printerName);
                                                        print('allPrinter $allPrinter');
                                                        if(allPrinter.isEmpty){
                                                          defaultPrinter =printerName ;
                                                          defaultIpAddress =ipAddress;
                                                          defaultPort = portNumber;
                                                        }
                                                        Navigator.pop(context);
                                                        setState((){
                                                          index=10;
                                                        });
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.all(8.0),
                                                        color: kBackgroundColor,
                                                        child: Text(
                                                          'SAVE',
                                                          style: TextStyle(
                                                            letterSpacing: 1.5,
                                                            fontSize: MediaQuery.of(
                                                                context)
                                                                .textScaleFactor *
                                                                20,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              });
                        },
                        color: kBackgroundColor,
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Add Printer',
                            style: TextStyle(
                              letterSpacing: 1.5,
                              fontSize: MediaQuery.of(context).textScaleFactor * 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 3.0,
                      ),
                      // Text(
                      //   'Default Printer',
                      //   style: TextStyle(
                      //     fontSize: MediaQuery.of(context).textScaleFactor * 20,
                      //   ),
                      // ),
                      // Container(
                      //   width: MediaQuery.of(context).size.width / 3,
                      //   height: 30.0,
                      //   decoration: BoxDecoration(
                      //     border: Border.all(
                      //         color: Colors.black38,
                      //         style: BorderStyle.solid,
                      //         width: 0.80),
                      //   ),
                      //   child: StreamBuilder(
                      //     stream: firebaseFirestore.collection('printer_data').snapshots(),
                      //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      //       if (!snapshot.hasData) {
                      //         return Center(
                      //           child: CircularProgressIndicator(),
                      //         );
                      //       }
                      //       return DropdownButtonHideUnderline(
                      //         child: DropdownButton(
                      //           icon: Icon(Icons.print),
                      //           elevation: 5,
                      //           value:defaultPrinter, // Not necessary for Option 1
                      //           items: snapshot.data.docs.map((DocumentSnapshot document) {
                      //             return DropdownMenuItem(
                      //               child: new Text(
                      //                 document['printerName'],
                      //                 style: TextStyle(
                      //                     fontSize: MediaQuery.of(context).textScaleFactor * 20,
                      //                     color: kBackgroundColor),
                      //               ),
                      //               value: document['printerName'],
                      //             );
                      //           }).toList(),
                      //           onChanged: (newValue) {
                      //             firebaseFirestore.collection('printer_data').doc(defaultPrinter).update({
                      //               'default':'false'
                      //             }).then((_) {
                      //               print('success');
                      //             });
                      //             firebaseFirestore.collection('printer_data').doc(newValue.toString()).update({
                      //               'default':'true'
                      //             }).then((_) {
                      //               print('success');
                      //             });
                      //             setState(() {
                      //               defaultPrinter=newValue.toString();
                      //             });
                      //           },
                      //         ),
                      //       );
                      //     },
                      //
                      //   ),
                      // ),
                      // Divider(
                      //   thickness: 3.0,
                      // ),
                      SizedBox(height: 20,),

                    ],
                  ),
                ),
                SizedBox(width: 20,),
                Expanded(
                  child: Column(
                    // scrollDirection: Axis.vertical,
                    // shrinkWrap: true,
                   mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'KOT Settings',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: MediaQuery.of(context).textScaleFactor * 40,
                          color: kBackgroundColor,
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        width: MediaQuery.of(context).size.width/4,
                        height: MediaQuery.of(context).size.height/4,
                        child: StreamBuilder(
                            stream: firebaseFirestore.collection('kot_data').snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot3) {
                              if (!snapshot3.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return ListView(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                children: snapshot3.data.docs.map((document)  {
                                  return ListTile(
                                    leading: Icon(Icons.print),
                                    title: Text(document['category']),
                                    subtitle: Column(
                                      children: [
                                        Text(document['printer']),
                                        Text(document['ip']),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete), onPressed: () {
                                      firebaseFirestore.collection('kot_data').doc(document['category']).delete();
                                    },
                                    ),
                                  );
                                }).toList(),
                              );
                            }),
                      ),
                      SizedBox(height: 20,),
                      Padding(
                        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/8,right:  MediaQuery.of(context).size.width/8),
                        child: MaterialButton(
                          child: Text(
                            'Add ',
                            style: TextStyle(
                                fontSize:
                                MediaQuery.of(context).textScaleFactor * 16,
                                color: Colors.white),
                          ),
                          color: kBackgroundColor,
                          onPressed: () {
                            print('clicked');
                            setState(() {
                              addKot++;
                              kotCategory.add(allCategoryList[0]);
                              kotPrinter.add(allPrinter[0]);
                            });
                          },
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: DataTable(
                            columns: [
                              DataColumn(
                                  label: Text(
                                    'Category',
                                    style: TextStyle(
                                      fontSize:
                                      MediaQuery.of(context).textScaleFactor * 20,
                                    ),
                                  )),
                              DataColumn(
                                  label: Text(
                                    'Printer',
                                    style: TextStyle(
                                      fontSize:
                                      MediaQuery.of(context).textScaleFactor * 20,
                                    ),
                                  )),
                              DataColumn(
                                  label: Text(
                                    '',
                                    style: TextStyle(
                                      fontSize:
                                      MediaQuery.of(context).textScaleFactor * 20,
                                    ),
                                  )),
                            ],
                            rows: List.generate(
                                addKot,
                                    (index) => DataRow(cells: [
                                  DataCell(
                                    DropdownButton(
                                      hint: Text(
                                        'Select Category',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                              .textScaleFactor *
                                              20,
                                        ),
                                      ),
                                      value: kotCategory[index],
                                      // Not necessary for Option 1
                                      items: allCategoryList.map((String val) {
                                        return DropdownMenuItem(
                                          child: new Text(
                                            val.toString(),
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                  .textScaleFactor *
                                                  20,
                                            ),
                                          ),
                                          value: val,
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          kotCategory[index] = newValue.toString();
                                        });
                                        print(kotCategory);
                                      },
                                    ),
                                  ),
                                  DataCell(
                                    DropdownButton(
                                      hint: Text(
                                        'Select Printer',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                              .textScaleFactor *
                                              20,
                                        ),
                                      ),
                                      value: kotPrinter[index].trim(),
                                      // Not necessary for Option 1
                                      items: allPrinter.map((String val) {
                                        return DropdownMenuItem(
                                          child: new Text(
                                            val.toString(),
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                  .textScaleFactor *
                                                  20,
                                            ),
                                          ),
                                          value: val,
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          kotPrinter[index] = newValue.toString();
                                        });
                                        print(kotPrinter);
                                      },
                                    ),
                                  ),
                                  DataCell(GestureDetector(
                                    child: IconButton(
                                      onPressed: () async {
                                        setState(() {
                                          addKot--;
                                          kotCategory.removeAt(index);
                                          kotPrinter.removeAt(index);
                                        });
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ))
                                ]))),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/8,right:  MediaQuery.of(context).size.width/8),

                        child: Visibility(
                          visible: addKot > 0 ? true : false,
                          child: MaterialButton(
                            child: Text(
                              'Save ',
                              style: TextStyle(
                                  fontSize:
                                  MediaQuery.of(context).textScaleFactor * 16,
                                  color: Colors.white),
                            ),
                            color: kBackgroundColor,
                            onPressed: () async {
                              String body = '';
                              String ip;
                              String tempPrinter;
                              for(int i=0;i<kotCategory.length;i++){
                                int pos= allPrinter.indexOf(kotPrinter[i]);
                                print('pos $pos');
                                firebaseFirestore.collection("kot_data").doc(kotCategory[i]).set(
                                    {
                                      'category': kotCategory[i],
                                      'printer': kotPrinter[i],
                                      'ip': allIp[pos],
                                    }).then((_){
                                  print('success');
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
    else if (index == 11) {
      // taxNameList.isNotEmpty?selectedVatExpense=taxNameList[1]:selectedVatExpense='';
      return Container(
        padding: EdgeInsets.all(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expense Head',
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: MediaQuery.of(context).textScaleFactor * 40,
                color: kBackgroundColor,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 3,
              height: 30.0,
              color: Colors.white,
              child: TextField(
                controller: expenseHeadController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.black38, width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38, width: 1.0),
                    ),
                    labelText: 'Expense Head ',
                    labelStyle: TextStyle(
                      color: Colors.black38,
                    )),
                onChanged: (value) {
                  expenseHead = value;
                },
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 3,
              height: 30.0,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black38,
                    style: BorderStyle.solid,
                    width: 0.80),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  hint: Text('  Tax List'),
                  value: selectedVatExpense,
                  items: taxNameList.map((value) {
                    return DropdownMenuItem(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      print(taxNameList);
                      selectedVatExpense = newValue.toString();
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 3,
              height: 30.0,
              color: Colors.white,
              child: TextField(
                controller: vatController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.black38, width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38, width: 1.0),
                    ),
                    labelText: 'VAT/GST NO',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    )),
                onChanged: (value) {
                  expenseVatNo = value;
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 3,
              height: 30.0,
              color: Colors.white,
              child: TextField(
                controller: expenseBalanceController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.black38, width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38, width: 1.0),
                    ),
                    labelText: 'Opening balance',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    )),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: TextButton(
                onPressed: () async {
                  if(expenseHead==''|| expenseVatNo==''){
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Error"),
                          content: Text("Fill all the fields"),
                          actions: <Widget>[
                            // usually buttons at the bottom of the dialog
                            new TextButton(
                              child: new Text("Close"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        )
                    );
                  }
                  else{
                    String body='$expenseHead~$expenseVatNo~$selectedVatExpense~${expenseBalanceController.text}';
                    create(body, 'expense_head');
                    expenseHead='';
                    expenseVatNo='';
                    expenseHeadController.clear();
                    expenseBalanceController.clear();
                    vatController.clear();
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'SAVE',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor * 20,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
    else if (index == 12) {
      return Container(
        padding: EdgeInsets.all(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Delivery Boy Details',
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: MediaQuery.of(context).textScaleFactor * 30,
                color: kBackgroundColor,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 3,
              height: 30.0,
              color: Colors.white,
              child: TextField(
                controller: deliveryNameController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.black38, width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38, width: 1.0),
                    ),
                    labelText: 'User Name',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    )),
                onChanged: (value) {
                  // userName = value;
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 3,
              height: 30.0,
              color: Colors.white,
              child: TextField(
                controller: deliveryPasswordController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.black38, width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38, width: 1.0),
                    ),
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    )),
                onChanged: (value) {
                  // password = value;
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 3,
              height: 30.0,
              color: Colors.white,
              child: TextField(
                controller: deliveryMobileController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    counterText: '',
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.black38, width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38, width: 1.0),
                    ),
                    labelText: 'mobile number',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    )),
                onChanged: (value) {
                  //   prefix = value;
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () async {
                  if(deliveryNameController.text==''|| deliveryPasswordController.text=='' || deliveryMobileController.text=='' ){
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Error"),
                          content: Text("Fill all the fields"),
                          actions: <Widget>[
                            // usually buttons at the bottom of the dialog
                            new TextButton(
                              child: new Text("Close"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        )
                    );
                  }
                  else{
                    String inside='not';
                    for(int i=0;i<taxNameList.length;i++){
                      if(userNameList[i].toLowerCase() == userName.toLowerCase().trim()){
                        inside='contains';
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Error"),
                              content: Text("User name Exists"),
                              actions: <Widget>[
                                // usually buttons at the bottom of the dialog
                                new TextButton(
                                  child: new Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            )
                        );
                      }
                    }
                    if(inside=='not'){
                      String body='${deliveryNameController.text}~${deliveryPasswordController.text}~${deliveryMobileController.text}';
                      create(body, 'deliverBoy_data');
                      deliveryNameController.clear();
                      deliveryPasswordController.clear();
                      deliveryMobileController.clear();
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'SAVE',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor * 20,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ))
          ],
        ),
      );
    }
    else if (index == 13) {
      TextStyle headingStyle=TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 20,);
      TextStyle contentStyle=TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 15,);
      return Container(
        padding: EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Import Data',
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: MediaQuery.of(context).textScaleFactor * 30,
                color: kBackgroundColor,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Container(
                  // width: MediaQuery.of(context).size.width / 3,
                  // height: 30.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 0.80),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: Obx(()=>DropdownButton(
                        // hint: Text('  Terminal List'),
                        value: importSelect.value,
                        items: importSelectList.map((value) {
                          return DropdownMenuItem(value: value, child: Text(value));
                        }).toList(),
                        onChanged: (newValue) {
                          importSelect.value = newValue.toString();
                          setState(() {
                            importId=[];
                          });
                        },
                      )),
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () async {
                      if(importSelect.value=='Product') {
                        importData = [];
                        importId = [];
                        importItem = [];
                        importCategory = [];
                        importItemCode = [];
                        importBarcodeType = [];
                        importUom = [];
                        importSp = [];
                        importPp = [];
                        importBarcode = [];
                        importConversion = [];
                        importTax = [];
                        importDiscount = [];
                        importProvision = [];
                        importBom = [];
                        importImage = [];
                        importStockQty=[];
                        importCostPrice=[];
                      }
                     else if(importSelect.value=='Customer') {
                        importData = [];
                        importId = [];
                        importCName = [];
                        importCAddress = [];
                        importCFlatNo = [];
                        importCBldNo = [];
                        importCRoadNo = [];
                        importCBlockNo = [];
                        importCArea = [];
                        importCLandmark = [];
                        importCNote = [];
                        importCMobileNo = [];
                        importCVatNo = [];
                        importCBalance = [];
                        importCPriceList = [];
                      }
                      else if(importSelect.value=='Vendor') {
                        importData = [];
                        importId = [];
                        importVName = [];
                        importVAddress = [];
                        importVMobileNo = [];
                        importVVatNo = [];
                        importVBalance = [];
                        importVPriceList = [];
                      }
                      else if(importSelect.value=='Expense'){
                        importData = [];
                        importId = [];
                        importEHead=[];importETaxName=[];importETaxNo=[];importEBalance=[];
                      }
                        FilePickerResult result = await FilePicker.platform.pickFiles( type: FileType.custom,
                        allowedExtensions: ['csv'],);

                      if (result != null) {
                          PlatformFile file = result.files.first;
                          String path=file.path;
                          print('path $path');
                          final input =  File(path).openRead();
                          importData = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
                          importData.removeAt(0);

                        String tempProvision='';
                        print('impoertData ${importData.length}');
                        setState(() {
                          uploadDataEnable=true;
                          if(importSelect.value=='Product') {
                            for (int i = 0; i < importData.length; i++) {
                              List temp = importData[i].toString().split(',');
                              importId.add(
                                  temp[0].toString().substring(1).trim());
                              importItem.add(temp[1].toString().trim());
                              importCategory.add(temp[2].toString().trim());
                              importItemCode.add(temp[3].toString().trim());
                              importBarcodeType.add(temp[4].toString().trim());
                              importUom.add(temp[5].toString().trim());
                              importSp.add(temp[6].toString().trim());
                              importPp.add(temp[7].toString().trim());
                              importBarcode.add(temp[8].toString().trim());
                              importConversion.add(temp[9].toString().trim());
                              importTax.add(temp[10].toString().trim());
                              importDiscount.add(temp[11].toString().trim());
                              importBom.add(temp[12].toString().trim());
                              importImage.add(temp[13].toString().trim());
                              importStockQty.add(temp[14].toString().trim());
                              importCostPrice.add(temp[15].toString().trim());
                              tempProvision = temp[16].toString().trim();
                              importProvision.add(tempProvision.substring(
                                  0, tempProvision.length - 1));
                            }
                          }
                          else if(importSelect.value=='Customer') {
                            for (int i = 0; i < importData.length; i++) {
                              List temp = importData[i].toString().split(',');
                              importId.add(
                                  temp[0].toString().substring(1).trim());
                              importCName.add(temp[1].toString().trim());
                              importCAddress.add(temp[2].toString().trim());
                              importCFlatNo.add(temp[3].toString().trim());
                              importCBldNo.add(temp[4].toString().trim());
                              importCRoadNo.add(temp[5].toString().trim());
                              importCBlockNo.add(temp[6].toString().trim());
                              importCArea.add(temp[7].toString().trim());
                              importCLandmark.add(temp[8].toString().trim());
                              importCNote.add(temp[9].toString().trim());
                              importCMobileNo.add(temp[10].toString().trim());
                              importCVatNo.add(temp[11].toString().trim());
                              importCBalance.add(temp[12].toString().trim());
                              tempProvision = temp[13].toString().trim();
                              print(tempProvision);
                              // importCPriceList.add(tempProvision.substring(
                              //     0, tempProvision.length - 1));
                              importCPriceList.add('Price 1');
                              importCRoute.add(temp[14].toString().trim());
                            }
                          }
                          else if(importSelect.value=='Vendor') {
                            for (int i = 0; i < importData.length; i++) {
                              List temp = importData[i].toString().split(',');
                              importId.add(
                                  temp[0].toString().substring(1).trim());
                              importVName.add(temp[1].toString().trim());
                              importVAddress.add(temp[2].toString().trim());
                              importVMobileNo.add(temp[3].toString().trim());
                              importVVatNo.add(temp[4].toString().trim());
                              importVBalance.add(temp[5].toString().trim());
                              tempProvision = temp[6].toString().trim();
                              importVPriceList.add(tempProvision.substring(
                                  0, tempProvision.length - 1));
                            }
                          }
                          else if(importSelect.value=='Expense') {
                            for (int i = 0; i < importData.length; i++) {
                              List temp = importData[i].toString().split(',');
                              importId.add(
                                  temp[0].toString().substring(1).trim());
                              importEHead.add(temp[1].toString().trim());
                              importETaxName.add(temp[2].toString().trim());
                              importETaxNo.add(temp[3].toString().trim());
                              tempProvision = temp[4].toString().trim();
                              importEBalance.add(tempProvision.substring(
                                  0, tempProvision.length - 1));
                            }
                          }
                          else if(importSelect.value=='Invoice') {
                            for (int i = 0; i < importData.length; i++) {
                              List temp = importData[i].toString().split(',');
                              importId.add(
                                  temp[0].toString().substring(1).trim());
                              importIBalance.add(temp[1].toString().trim());
                              importICart.add(temp[2].toString().trim());
                              importICreatedBy.add(temp[3].toString().trim());
                              importIDate.add(temp[3].toString().trim());
                              importIDeliveryBoy.add(temp[3].toString().trim());
                              importIDType.add(temp[3].toString().trim());
                              importIDiscount.add(temp[3].toString().trim());
                              importIKotNo.add(temp[3].toString().trim());
                              importIOrderNo.add(temp[3].toString().trim());
                              importIPayment.add(temp[3].toString().trim());
                              importITotal.add(temp[3].toString().trim());
                              importITType.add(temp[3].toString().trim());
                              tempProvision = temp[4].toString().trim();
                              importIUser.add(tempProvision.substring(
                                  0, tempProvision.length - 1));
                            }
                          }
                        });
                      }

                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Import CSV',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor * 20,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: kBackgroundColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    )
                ),
              ],
            ),
            Obx(()=>  Expanded(
              child: SingleChildScrollView(
                //scrollDirection: Axis.horizontal,
                scrollDirection: Axis.vertical,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 3,
                    //  width:MediaQuery.of(context).size.width,
                    child: importSelect.value=='Product'?DataTable(columns: [
                      DataColumn(label: Text('Id', style: headingStyle,)),
                      DataColumn(label: Text('ItemName', style: headingStyle,)),
                      DataColumn(label: Text('Category', style: headingStyle,)),
                      DataColumn(label: Text('ItemCode', style: headingStyle,)),
                      DataColumn(label: Text('BarcodeType', style:headingStyle,)),
                      DataColumn(label: Text('UOM', style: headingStyle,)),
                      DataColumn(label: Text('S.P', style: headingStyle,)),
                      DataColumn(label: Text('P.P', style: headingStyle,)),
                      DataColumn(label: Text('Barcode', style: headingStyle,)),
                      DataColumn(label: Text('Conversion', style: headingStyle,)),
                      DataColumn(label: Text('Tax', style: headingStyle,)),
                      DataColumn(label: Text('Discount', style: headingStyle,)),
                      DataColumn(label: Text('Bom', style: headingStyle,)),
                      DataColumn(label: Text('Image', style: headingStyle,)),
                      DataColumn(label: Text('StockQty', style: headingStyle,)),
                      DataColumn(label: Text('Cost', style: headingStyle,)),
                      DataColumn(label: Text('Provision', style: headingStyle,)),
                    ],
                        rows: List.generate(importId.length, (index) => DataRow(cells: [
                          DataCell(Text(importId[index],style: contentStyle)),
                          DataCell(SizedBox(width:200,child: Text(importItem[index],maxLines: 3,style: contentStyle))),
                          DataCell(Text(importCategory[index],style: contentStyle)),
                          DataCell(Text(importItemCode[index],style: contentStyle)),
                          DataCell(Text(importBarcodeType[index],style: contentStyle)),
                          DataCell(Text(importUom[index],style: contentStyle)),
                          DataCell(Text(importSp[index],style: contentStyle)),
                          DataCell(Text(importPp[index],style: contentStyle)),
                          DataCell(Text(importBarcode[index],style: contentStyle)),
                          DataCell(Text(importConversion[index],style: contentStyle)),
                          DataCell(Text(importTax[index],style: contentStyle)),
                          DataCell(Text(importDiscount[index],style: contentStyle)),
                          DataCell(Text(importBom[index],style: contentStyle)),
                          DataCell(Text(importImage[index].length>0?importImage[index].substring(0,10):importImage[index],style: contentStyle)),
                          DataCell(Text(importStockQty[index],style: contentStyle)),
                          DataCell(Text(importCostPrice[index],style: contentStyle)),
                          DataCell(Text(importProvision[index],style: contentStyle)),
                        ]))):
                    importSelect.value=='Customer'? DataTable(columns: [
                      DataColumn(label: Text('Id', style: headingStyle,)),
                      DataColumn(label: Text('Name', style: headingStyle,)),
                      DataColumn(label: Text('Address', style: headingStyle,)),
                      DataColumn(label: Text('FlatNo', style: headingStyle,)),
                      DataColumn(label: Text('BLDNO', style:headingStyle,)),
                      DataColumn(label: Text('RoadNo', style: headingStyle,)),
                      DataColumn(label: Text('BlockNo', style: headingStyle,)),
                      DataColumn(label: Text('Area', style: headingStyle,)),
                      DataColumn(label: Text('Landmark', style: headingStyle,)),
                      DataColumn(label: Text('Note', style: headingStyle,)),
                      DataColumn(label: Text('MobileNo', style: headingStyle,)),
                      DataColumn(label: Text(fb.organisationTaxType=='GST'?'GSTNO':'VATNO', style: headingStyle,)),
                      DataColumn(label: Text('Balance', style: headingStyle,)),
                      DataColumn(label: Text('PriceList', style: headingStyle,)),
                    ],
                        rows: List.generate(importId.length, (index) => DataRow(cells: [
                          DataCell(Text(importId[index],style: contentStyle)),
                          DataCell(Text(importCName[index],style: contentStyle)),
                          DataCell(Text(importCAddress[index],style: contentStyle)),
                          DataCell(Text(importCFlatNo[index],style: contentStyle)),
                          DataCell(Text(importCBldNo[index],style: contentStyle)),
                          DataCell(Text(importCRoadNo[index],style: contentStyle)),
                          DataCell(Text(importCBlockNo[index],style: contentStyle)),
                          DataCell(Text(importCArea[index],style: contentStyle)),
                          DataCell(Text(importCLandmark[index],style: contentStyle)),
                          DataCell(Text(importCNote[index],style: contentStyle)),
                          DataCell(Text(importCMobileNo[index],style: contentStyle)),
                          DataCell(Text(importCVatNo[index],style: contentStyle)),
                          DataCell(Text(importCBalance[index],style: contentStyle)),
                          DataCell(Text(importCPriceList[index],style: contentStyle)),
                        ]))):
                    importSelect.value=='Vendor'? DataTable(columns: [
                      DataColumn(label: Text('Id', style: headingStyle,)),
                      DataColumn(label: Text('Name', style: headingStyle,)),
                      DataColumn(label: Text('Address', style: headingStyle,)),
                      DataColumn(label: Text('MobileNo', style: headingStyle,)),
                      DataColumn(label: Text(fb.organisationTaxType=='GST'?'GSTNO':'VATNO', style: headingStyle,)),
                      DataColumn(label: Text('Balance', style: headingStyle,)),
                      DataColumn(label: Text('PriceList', style: headingStyle,)),
                    ],
                        rows: List.generate(importId.length, (index) => DataRow(cells: [
                          DataCell(Text(importId[index],style: contentStyle)),
                          DataCell(Text(importVName[index],style: contentStyle)),
                          DataCell(Text(importVAddress[index],style: contentStyle)),
                          DataCell(Text(importVMobileNo[index],style: contentStyle)),
                          DataCell(Text(importVVatNo[index],style: contentStyle)),
                          DataCell(Text(importVBalance[index],style: contentStyle)),
                          DataCell(Text(importVPriceList[index],style: contentStyle)),
                        ]))):  importSelect.value=='Expense'?
                    DataTable(columns: [
                      DataColumn(label: Text('Id', style: headingStyle,)),
                      DataColumn(label: Text('ExpenseHead', style: headingStyle,)),
                      DataColumn(label: Text('Tax', style: headingStyle,)),
                      DataColumn(label: Text(fb.organisationTaxType=='GST'?'GSTNO':'VATNO', style: headingStyle,)),
                      DataColumn(label: Text('Balance', style: headingStyle,)),
                    ],
                        rows: List.generate(importId.length, (index) => DataRow(cells: [
                          DataCell(Text(importId[index],style: contentStyle)),
                          DataCell(Text(importEHead[index],style: contentStyle)),
                          DataCell(Text(importETaxName[index],style: contentStyle)),
                          DataCell(Text(importETaxNo[index],style: contentStyle)),
                          DataCell(Text(importEBalance[index],style: contentStyle)),
                        ]))):
                    DataTable(columns: [
                      DataColumn(label: Text('Id', style: headingStyle,)),
                      DataColumn(label: Text('Balance', style: headingStyle,)),
                      DataColumn(label: Text('Items', style: headingStyle,)),
                      DataColumn(label: Text('createdBy', style: headingStyle,)),
                      DataColumn(label: Text('customer', style: headingStyle,)),
                      DataColumn(label: Text('date', style: headingStyle,)),
                      DataColumn(label: Text('deliveryBoy', style: headingStyle,)),
                      DataColumn(label: Text('deliveryType', style: headingStyle,)),
                      DataColumn(label: Text('discount', style: headingStyle,)),
                      DataColumn(label: Text('kotNo', style: headingStyle,)),
                      DataColumn(label: Text('OrderNo', style: headingStyle,)),
                      DataColumn(label: Text('payment', style: headingStyle,)),
                      DataColumn(label: Text('total', style: headingStyle,)),
                      DataColumn(label: Text('transaction', style: headingStyle,)),
                      DataColumn(label: Text('user', style: headingStyle,)),
                    ],
                        rows: List.generate(importId.length, (index) => DataRow(cells: [
                          DataCell(Text(importId[index],style: contentStyle)),
                          DataCell(Text(importIBalance[index],style: contentStyle)),
                          DataCell(Text(importICart[index],style: contentStyle)),
                          DataCell(Text(importICreatedBy[index],style: contentStyle)),
                          DataCell(Text(importICustomer[index],style: contentStyle)),
                          DataCell(Text(importIDate[index],style: contentStyle)),
                          DataCell(Text(importIDeliveryBoy[index],style: contentStyle)),
                          DataCell(Text(importIDType[index],style: contentStyle)),
                          DataCell(Text(importIDiscount[index],style: contentStyle)),
                          DataCell(Text(importIKotNo[index],style: contentStyle)),
                          DataCell(Text(importIOrderNo[index],style: contentStyle)),
                          DataCell(Text(importIPayment[index],style: contentStyle)),
                          DataCell(Text(importITotal[index],style: contentStyle)),
                          DataCell(Text(importITType[index],style: contentStyle)),
                          DataCell(Text(importIUser[index],style: contentStyle)),
                        ]))),
                  ),
                ),
              ),
            ),),
            Visibility(
                visible: importData.isNotEmpty?true:false,
                child: TextButton(
                    onPressed:uploadDataEnable==true? ()async {
                      setState(() {
                        uploadDataEnable=false;
                      });
                      if(importSelect.value=='Product') {
                        List tempUom=[];
                        for(int i=0;i<importUom.length;i++){
                            String str='${importUom[i]}*``${importSp[i]}*``${importPp[i]}*``${importBarcode[i]}*``${importConversion[i]}*';
                       tempUom.add(str);
                        }
                              await uploadData(importItem, importCategory,
                                  importItemCode, importBarcodeType, tempUom, importTax, importDiscount, importBom, importProvision, importImage, importStockQty, importCostPrice);
                            }
                           else if(importSelect.value=='Customer') {
                        await uploadCustomer(
                            importCName,
                            importCAddress,
                            importCFlatNo,
                            importCBldNo,
                            importCBlockNo,
                            importCRoadNo,
                            importCArea,
                            importCLandmark,
                            importCNote,
                            importCMobileNo,
                            importCVatNo,
                            importCBalance,
                            importCPriceList,
                            importCRoute
                        );
                      }
                     else if(importSelect.value=='Vendor') {
                        await uploadVendor(
                            importVName, importVAddress, importVMobileNo,
                            importCVatNo, importVBalance, importVPriceList);
                      }
                     else if(importSelect.value=='Expense') {
                        await uploadExpense(
                            importEHead, importETaxName, importETaxNo,
                            importEBalance);
                      }
                      else if(importSelect.value=='Invoice') {
                        await uploadInvoice(
                            importIBalance, importICart, importICreatedBy,
                            importICustomer,importIDate,importIDeliveryBoy,importIDType,importIDiscount,importIKotNo,importIOrderNo,importIPayment,importITotal,importITType,importIUser);
                      }
                    }:null,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Upload',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor * 20,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: kBackgroundColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    )))
          ],
        ),
      );
    }
    else if(index==14){
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.all(25.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              // scrollDirection: Axis.vertical,
              // shrinkWrap: true,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Table Settings',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: MediaQuery.of(context).textScaleFactor * 30,
                    color: kBackgroundColor,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextButton(
                    onPressed: ()  {
                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height/4,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text('Name',style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                        ),),
                                        const SizedBox(width: 20,),
                                        Container(
                                          width: MediaQuery.of(context).size.width / 3,
                                          //height: 30.0,
                                          color: Colors.white,
                                          child: TextField(
                                            controller: floorNameController,
                                            decoration: const InputDecoration(
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Colors.black38, width: 1.0)),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.black38, width: 1.0),
                                                ),
                                                labelText: 'Floor name',
                                                labelStyle: TextStyle(
                                                  color: Colors.black38,
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        TextButton(
                                            onPressed: ()  {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'CANCEL',
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context).textScaleFactor * 20,
                                                  color: Colors.white,
                                                  letterSpacing: 1.5,
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                color: kBackgroundColor,
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                            )),
                                        SizedBox(height:20),
                                        TextButton(
                                            onPressed: ()  {
                                              if(floorNameController.text.length==0){
                                                showDialog(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                      title: Text("Error"),
                                                      content: Text("Fill all the fields"),
                                                      actions: <Widget>[
                                                        // usually buttons at the bottom of the dialog
                                                        new TextButton(
                                                          child: new Text("Close"),
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                        ),
                                                      ],
                                                    )
                                                );
                                              }
                                              else{
                                                create(floorNameController.text, 'floor_data');
                                                floorNameController.clear();
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'CONFIRM',
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context).textScaleFactor * 20,
                                                  color: Colors.white,
                                                  letterSpacing: 1.5,
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                color: kBackgroundColor,
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Add Floor',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor * 20,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: kBackgroundColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    )),
                SizedBox(
                  height: 30,
                ),
                TextButton(
                    onPressed: ()  {
                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height/3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('Area',style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                            ),),
                                            SizedBox(width: 20,),
                                            Container(
                                              width: MediaQuery.of(context).size.width / 3,
                                              height: 30.0,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black38,
                                                    style: BorderStyle.solid,
                                                    width: 0.80),
                                              ),
                                              child: StreamBuilder(
                                                stream: firebaseFirestore.collection('floor_data').snapshots(),
                                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child: CircularProgressIndicator(),
                                                    );
                                                  }
                                                  return DropdownButtonHideUnderline(
                                                    child: Obx(()=>
                                                        DropdownButton(
                                                      //  icon: Icon(Icons.print),
                                                      elevation: 5,
                                                      value:selectedFloor.value, // Not necessary for Option 1
                                                      items: snapshot.data.docs.map((DocumentSnapshot document) {
                                                        return DropdownMenuItem(
                                                          child: new Text(
                                                            document['floorName'],
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(context).textScaleFactor * 20,
                                                                color: kBackgroundColor),
                                                          ),
                                                          value: document['floorName'],
                                                        );
                                                      }).toList(),
                                                      onChanged: (newValue) {
                                                        selectedFloor.value=newValue.toString();
                                                        print('selectedFloor $selectedFloor');
                                                      },
                                                    )),
                                                  );
                                                },

                                              ),
                                            ),
                                          ],
                                        ),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('Table No',style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                            ),),
                                            SizedBox(width: 20,),
                                            Container(
                                              width: MediaQuery.of(context).size.width / 4,
                                              //height: 30.0,
                                              color: Colors.white,
                                              child: TextField(
                                                controller: tableNameController,
                                                // keyboardType:
                                                // TextInputType.number,
                                                // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                decoration: InputDecoration(
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(color: Colors.black38, width: 1.0)),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.black38, width: 1.0),
                                                    ),
                                                    // labelText: 'Table name',
                                                    labelStyle: TextStyle(
                                                      color: Colors.black38,
                                                    )),
                                              ),
                                            ),
                                            SizedBox(width: 20,),
                                            Text('Pax',style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                            ),),
                                            SizedBox(width: 20,),
                                            Container(
                                              width: MediaQuery.of(context).size.width / 4,
                                              //height: 30.0,
                                              color: Colors.white,
                                              child: TextField(
                                                keyboardType:
                                                TextInputType.number,
                                               inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                controller: tablePaxController,
                                                decoration: InputDecoration(
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(color: Colors.black38, width: 1.0)),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.black38, width: 1.0),
                                                    ),
                                                    //labelText: 'Floor name',
                                                    labelStyle: TextStyle(
                                                      color: Colors.black38,
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                            onPressed: ()  {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'CANCEL',
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context).textScaleFactor * 20,
                                                  color: Colors.white,
                                                  letterSpacing: 1.5,
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                color: kBackgroundColor,
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                            )),
                                        SizedBox(height:10),
                                        TextButton(
                                            onPressed: ()  {
                                              if(tableNameController.text.isEmpty || tablePaxController.text.isEmpty || selectedFloor==''){
                                                showDialog(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                      title: Text("Error"),
                                                      content: Text("Fill all the fields"),
                                                      actions: <Widget>[
                                                        // usually buttons at the bottom of the dialog
                                                        new TextButton(
                                                          child: new Text("Close"),
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                        ),
                                                      ],
                                                    )
                                                );
                                              }
                                              else{
                                                String body='${tableNameController.text}~$selectedFloor~${tablePaxController.text}';
                                                create(body, 'table_data');
                                                tableNameController.clear();
                                                tablePaxController.clear();
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'CONFIRM',
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context).textScaleFactor * 20,
                                                  color: Colors.white,
                                                  letterSpacing: 1.5,
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                color: kBackgroundColor,
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Add Table',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor * 20,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: kBackgroundColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    )),
                SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: StreamBuilder(
                        stream: firebaseFirestore.collection('floor_data').snapshots(),
                        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot2) {
                          if (!snapshot2.hasData) {
                            return Center(
                              child: Text('Empty'),
                            );
                          }
                          return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              // scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: snapshot2.data.docs.length,
                              itemBuilder: (context,index1){
                                String floor=snapshot2.data.docs[index1]['floorName'];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(floor,style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: MediaQuery.of(context).textScaleFactor * 15,
                                      color: kBackgroundColor,
                                    ),),
                                    SizedBox(height:10),
                                    StreamBuilder(
                                        stream: firebaseFirestore.collection('table_data').where('area',isEqualTo:floor).snapshots(),
                                        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot3) {
                                          if (!snapshot3.hasData) {
                                            return Center(
                                              child: Text('Empty'),
                                            );
                                          }
                                          return GridView.builder(
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 5,
                                                childAspectRatio:
                                                MediaQuery.of(context).size.width /
                                                    (MediaQuery.of(context).size.height ),
                                              ),
                                              scrollDirection: Axis.vertical,
                                              itemCount: snapshot3.data.docs.length,
                                              itemBuilder: (context, index8) {
                                                return   Padding(
                                                  padding: const EdgeInsets.only(left: 6,right: 6,bottom: 6),
                                                  child:   Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(

                                                          color:kBackgroundColor,

                                                          style: BorderStyle.solid,

                                                          width: 0.80),

                                                    ),

                                                    child: Stack(children: [

                                                      Positioned.fill(child: Align(alignment: Alignment.center,child: Text(snapshot3.data.docs[index8]['tableName'],style: TextStyle(fontWeight: FontWeight.bold,),))),

                                                      Positioned.fill(right: 5.0,top: 5.0,child: Align(alignment: Alignment.topRight,child: Text('''${snapshot3.data.docs[index8]['pax']} Pax''',style: TextStyle(fontWeight: FontWeight.bold,)))),
                                                      Positioned.fill(right: 5.0,top: 5.0,child: Align(alignment: Alignment.bottomRight,child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          IconButton(onPressed: (){
                                                            showDialog(
                                                              context: context,
                                                              builder: (context) => new AlertDialog(
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                                                title: new Text('Are you sure?'),
                                                                content: new Text('Delete ${snapshot3.data.docs[index8]['tableName']} '),
                                                                actions: <Widget>[
                                                                  new TextButton(
                                                                    onPressed: () => Navigator.of(context).pop(false),
                                                                    child: Container(
                                                                        padding: EdgeInsets.all(6.0),
                                                                        width: 100,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                            border: Border.all(color: kBlack)
                                                                        ),
                                                                        child: Center(
                                                                          child: Text("Cancel",style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.bold
                                                                          ),),
                                                                        )),
                                                                  ),
                                                                  SizedBox(height: 16),

                                                                  new TextButton(
                                                                    onPressed: ()  {
                                                                      firebaseFirestore.collection('table_data').doc(snapshot3.data.docs[index8].id).delete();
                                                                      Navigator.pop(context);
                                                                    } ,
                                                                    child: Container(
                                                                        padding: EdgeInsets.all(6.0),
                                                                        width: 100,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                            border: Border.all(color: kBlack)
                                                                        ),
                                                                        child: Center(child: Text("Delete",style: TextStyle(
                                                                            color: Colors.black,
                                                                            fontWeight: FontWeight.bold
                                                                        )))),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },icon:Icon(Icons.delete),),
                                                        ],
                                                      ))),



                                                    ],),



                                                  ),
                                                );
                                              }
                                          );
                                        }
                                    ),
                                    Divider(thickness: 1.0,color: kBackgroundColor,),
                                  ],
                                );
                              }
                          );
                        }
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
    else if(index==15){
      return Container(
        padding: EdgeInsets.all(50.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Text(
              'Export Data',
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: MediaQuery.of(context).textScaleFactor * 30,
                color: kBackgroundColor,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                // Container(
                //   // width: MediaQuery.of(context).size.width / 4,
                //   // height: 30.0,
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //         color: Colors.black,
                //         style: BorderStyle.solid,
                //         width: 0.80),
                //   ),
                //   child: DropdownButtonHideUnderline(
                //     child: ButtonTheme(
                //       alignedDropdown: true,
                //       child:Obx(()=> DropdownButton(
                //         value: exportSelect.value,
                //         items: exportSelectList.map((value) {
                //           return DropdownMenuItem(value: value, child: Text(value));
                //         }).toList(),
                //         onChanged: (newValue) {
                //           exportSelect.value= newValue.toString();
                //         },
                //       ),)
                //     ),
                //   ),
                // ),
                TextButton(
                    onPressed: () async {
                      datePicked = await showDatePicker(
                        context: context,
                        initialDate: new DateTime.now(),
                        firstDate:
                        new DateTime.now().subtract(new Duration(days: 300)),
                        lastDate:
                        new DateTime.now().add(new Duration(days: 300)),
                      );
                      fromDate = datePicked;

                      setState(() {
                        fromDate1=fromDate.millisecondsSinceEpoch;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        // color: kCardColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'From :',
                            style: TextStyle(
                                letterSpacing: 1,
                                color: kGreenColor,
                                fontWeight: FontWeight.bold
                            ),
                          ),

                          Text(fromDate!=null?fromDate.toString():"",style: TextStyle(color: kGreenColor),)
                        ],
                      ),
                    )),
                TextButton(
                  onPressed: () async {
                    datePicked = await showDatePicker(
                      context: context,
                      initialDate: new DateTime.now(),
                      firstDate:
                      new DateTime.now().subtract(new Duration(days: 300)),
                      lastDate: new DateTime.now().add(new Duration(days: 300)),
                    );
                    toDate = datePicked;
                    setState(() {
                      toDate1=toDate.millisecondsSinceEpoch;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      //color: kCardColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'To :',
                          style: TextStyle(
                            letterSpacing: 1,
                            color: kGreenColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(toDate.toString(),style: TextStyle(color: kGreenColor),),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    int slN0=1;
                    // List<List<String>> item_data = [
                    //   [ "orderNo","date","items"],
                    // ];
                    // QuerySnapshot<Map<String, dynamic>> document=await firebaseFirestore.collection('item_report').get();
                    // for(int i=0;i<document.docs.length;i++){
                    //     String items='''${document.docs[i]['category']}:${document.docs[i]['name'].toString().replaceAll('#', '/')}:${document.docs[i]['price']}:${document.docs[i]['qty']}:${document.docs[i]['taxAmt']}:${document.docs[i]['itemTax']}:${document.docs[i]['taxPercent']}:${document.docs[i]['uom']}''';
                    //     item_data.add([document.docs[i].get('orderNo'),document.docs[i].get('date').toString(),items]);
                    // }
                    // // List<List<String>> data = [
                    // //   ["No.", "OrderNO", "Type","Date","Items","Discount","Total","Party Name","Organisation","Payment Mode","User"],
                    // // ];
                    // // QuerySnapshot<Map<String, dynamic>> document=await firebaseFirestore.collection('invoice_data').where('date',isGreaterThanOrEqualTo: fromDate1)
                    // //     .where('date',isLessThanOrEqualTo: toDate1).get();
                    // // for(int i=0;i<document.docs.length;i++){
                    // //   String date=convertEpox(document.docs[i].get('date')).substring(0,16);
                    // //   String items='';
                    // //   for(int j=0;j<document.docs[i]['cartList'].length;j++){
                    // //     if(j!=0)
                    // //       items+=',';
                    // //     items+='${document.docs[i]['cartList'][j]['name']}:${document.docs[i]['cartList'][j]['qty']}';
                    // //   }
                    // //   data.add(["${slN0++}",document.docs[i].get('orderNo'),document.docs[i].get('transactionType'),date,items,document.docs[i].get('discount'),
                    // //     document.docs[i].get('total'),document.docs[i].get('customer'),fb.organisationName,document.docs[i].get('payment'),document.docs[i].get('user')]);
                    // // }
                    // // // print('invoice $data');
                    // // QuerySnapshot<Map<String, dynamic>> document1=await firebaseFirestore.collection('sales_return').where('date',isGreaterThanOrEqualTo: fromDate1)
                    // //     .where('date',isLessThanOrEqualTo: toDate1).get();
                    // // print('1');
                    // // for(int i=0;i<document1.docs.length;i++){
                    // //   print('inside for');
                    // //   String date=convertEpox(document1.docs[i].get('date')).substring(0,16);
                    // //   String items='';
                    // //   for(int j=0;j<document1.docs[i]['cartList'].length;j++){
                    // //     if(j!=0)
                    // //       items+=',';
                    // //     items+='${document1.docs[i]['cartList'][j]['name']}:${document1.docs[i]['cartList'][j]['qty']}';
                    // //   }
                    // //   print('before data add ${document1.docs[i].id}');
                    // //   data.add(["${slN0++}",document1.docs[i].get('orderNo'),document1.docs[i].get('transactionType'),date,items,'0',
                    // //     document1.docs[i].get('total'),document1.docs[i].get('customer'),fb.organisationName,document1.docs[i].get('payment'),document1.docs[i].get('user')]);
                    // // print('after data add');
                    // // }
                    // // print('sales return');
                    // // QuerySnapshot<Map<String, dynamic>> document2=await firebaseFirestore.collection('purchase').where('date',isGreaterThanOrEqualTo: fromDate1)
                    // //     .where('date',isLessThanOrEqualTo: toDate1).get();
                    // // for(int i=0;i<document2.docs.length;i++){
                    // //   String date=convertEpox(document2.docs[i].get('date')).substring(0,16);
                    // //   String items='';
                    // //   for(int j=0;j<document2.docs[i]['cartList'].length;j++){
                    // //     if(j!=0)
                    // //       items+=',';
                    // //     items+='${document2.docs[i]['cartList'][j]['name']}:${document2.docs[i]['cartList'][j]['qty']}';
                    // //   }
                    // //   data.add(["${slN0++}",document2.docs[i].get('orderNo'),document2.docs[i].get('transactionType'),date,items,'0',
                    // //     document2.docs[i].get('total'),document2.docs[i].get('vendor'),fb.organisationName,document2.docs[i].get('payment'),document2.docs[i].get('user')]);
                    // // }
                    // // print('purchase');
                    // // QuerySnapshot<Map<String, dynamic>> document3=await firebaseFirestore.collection('purchase_return').where('date',isGreaterThanOrEqualTo: fromDate1)
                    // //     .where('date',isLessThanOrEqualTo: toDate1).get();
                    // // for(int i=0;i<document3.docs.length;i++){
                    // //   String date=convertEpox(document3.docs[i].get('date')).substring(0,16);
                    // //   String items='';
                    // //   for(int j=0;j<document3.docs[i]['cartList'].length;j++){
                    // //     if(j!=0)
                    // //       items+=',';
                    // //     items+='${document3.docs[i]['cartList'][j]['name']}:${document3.docs[i]['cartList'][j]['qty']}';
                    // //   }
                    // //   data.add(["${slN0++}",document3.docs[i].get('orderNo'),document3.docs[i].get('transactionType'),date,items,'0',
                    // //     document3.docs[i].get('total'),document3.docs[i].get('vendor'),fb.organisationName,document3.docs[i].get('payment'),document3.docs[i].get('user')]);
                    // // }
                    // // print('purchase return');
                    // // QuerySnapshot<Map<String, dynamic>> document4=await firebaseFirestore.collection('expense_transaction').where('date',isGreaterThanOrEqualTo: fromDate1)
                    // //     .where('date',isLessThanOrEqualTo: toDate1).get();
                    // // for(int i=0;i<document4.docs.length;i++){
                    // //   String date=convertEpox(document4.docs[i].get('date')).substring(0,16);
                    // //   data.add(["${slN0++}",document4.docs[i].get('orderNo'),'Expense',date,document4.docs[i].get('note'),'0',
                    // //     document4.docs[i].get('total'),document4.docs[i].get('expense'),fb.organisationName,document4.docs[i].get('payment'),document4.docs[i].get('user')]);
                    // // }
                    // // print('expense');
                    // // String csvData = ListToCsvConverter().convert(data);
                    // // String csvData = ListToCsvConverter().convert(item_data);
                    // String csvData1 = ListToCsvConverter().convert(item_data);
                    // new ht.AnchorElement(href: "data:text/plain;charset=utf-8,$csvData1")
                    //   ..setAttribute("download", "taza2.csv")
                    //   ..click();
// new ht.AnchorElement(href: "data:text/plain;charset=utf-8,$csvData")
//                       ..setAttribute("download", "tx_data${dateNow()}.csv")
//                       ..click();

                  },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Export CSV',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor * 20,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: kBackgroundColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    )
                )
              ],
            ),
          ]
        ),
      );
    }
    else if(index==16){
      return Container(
        padding: EdgeInsets.all(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Mode',
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: MediaQuery.of(context).textScaleFactor * 40,
                color: kBackgroundColor,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 3,
              height: 30.0,
              color: Colors.white,
              child: TextField(
                controller: mainPaymentController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.black38, width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38, width: 1.0),
                    ),
                    labelText: 'payment mode',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    )),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () async {
                  if(mainPaymentController.text.trim().length==0 ){
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Error"),
                          content: Text("Fill the field"),
                          actions: <Widget>[
                            // usually buttons at the bottom of the dialog
                            new TextButton(
                              child: new Text("Close"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        )
                    );
                  }
                  else{
                    String inside='not';
                    for(int i=0;i<mainPaymentList.length;i++){
                      if(mainPaymentList[i].toLowerCase() == mainPaymentController.text.toLowerCase().trim()){
                        inside='contains';
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Error"),
                              content: Text("Payment mode Exists"),
                              actions: <Widget>[
                                // usually buttons at the bottom of the dialog
                                new TextButton(
                                  child: new Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            )
                        );
                      }
                    }
                    if(inside=='not'){
                      String body=mainPaymentController.text.trim();
                      create(body, 'main_paymentList');
                      setState(() {
                        mainPaymentList.add(mainPaymentController.text.trim());
                      });
                      mainPaymentController.clear();
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'SAVE',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor * 20,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ))
          ],
        ),
      );
    }
    else if(index==17){
      return Container(
        padding: EdgeInsets.all(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Route',
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: MediaQuery.of(context).textScaleFactor * 40,
                color: kBackgroundColor,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 3,
              height: 30.0,
              color: Colors.white,
              child: TextField(
                controller: routefield,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.black38, width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38, width: 1.0),
                    ),
                    labelText: 'Route Name ',
                    labelStyle: TextStyle(
                      color: Colors.black38,
                    )),
                onChanged: (value) {
                 routenameadd = value;
                },
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: TextButton(
                onPressed: () async {
                  if(routenameadd==''){
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Error"),
                          content: Text("Fill all the fields"),
                          actions: <Widget>[
                            // usually buttons at the bottom of the dialog
                            new TextButton(
                              child: new Text("Close"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        )
                    );
                  }
                  else{
                    String inside='not';
                    for(int i=0;i<currentroutes.length;i++){
                      if(currentroutes[i].toLowerCase() == routenameadd.toLowerCase().trim()){
                        inside='contains';
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Error"),
                              content: Text("UOM name Exists"),
                              actions: <Widget>[
                                // usually buttons at the bottom of the dialog
                                new TextButton(
                                  child: new Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            )
                        );
                      }
                    }
                    if(inside=='not'){

                      setState(() {
                        currentroutes.add(routenameadd);
                    routefield.clear();
                      });
                      create(routenameadd, 'route_data');
                      //await insertData(body.substring(0,body.length-1),'uom_data');
                      routenameadd='';
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'SAVE',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor * 20,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
    return Text('');
  }
}
Future getOrganisationData()async{
  await read('organisation');
  List  tempData= [];
  try {
    tempData = organisationData.split('~');
    orgNameController.text = orgName = tempData[0].toString().trim();
    selectedBusiness = tempData[1].toString().trim();
    orgAddressController.text = orgAddress = tempData[2].toString().trim();
    orgMobileNoController.text = orgMobileNo = tempData[3].toString().trim();
    orgVatNoController.text = orgVatNo = tempData[4].toString().trim();
    currencyController.text = currency = tempData[5].toString().trim();
    symbolController.text = symbol = tempData[6].toString().trim();
    orgDecimalsController.text = orgDecimals = tempData[7].toString().trim();
    selectScreen=tempData[8].toString().trim();
    selectedTax=tempData[9].toString().trim();
    selectedCloseHour=tempData[18].toString().trim();
    orgTaxTitleController.text=tempData[10].toString().trim();
    // discountEnable=tempData[11].toString().trim();
    // _orgDiscount=discountEnable=='Yes'?selectedDiscount.Yes:selectedDiscount.No;
    invPrint=tempData[11].toString().trim();
    callCenterEnable=tempData[12].toString().trim();
    orgInvEdit.value=tempData[13].toString().trim()=='true'?true:false;
    orgCallCenter.value=tempData[14].toString().trim()=='true'?true:false;
    orgMultiLineInvoice.value=tempData[15].toString().trim()=='true'?true:false;
    orgQRCode.value=tempData[16].toString().trim()=='true'?true:false;
    orgCompositeTax.value=tempData[17].toString().trim()=='true'?true:false;
    orgWaiterCheckout.value=tempData[19].toString().trim()=='true'?true:false;
    _invoicePrint=invPrint=='One'?selectedInvoicePrint.One:selectedInvoicePrint.Two;
    _callCenter=callCenterEnable=='Yes'?callCenterSelected.Yes:callCenterSelected.No;
  }catch(Exception ){}
  return;
}
Future getSequenceData()async{
  await read('sequence');
  seqPrefixController=[];
  fromController=[];
  transactionTypeFrom=[];
  transactionTypePrefix=[];
  if(sequenceData==''){
    for(int i=0;i<type.length;i++){
      print(i);
      transactionTypePrefix.add('');
      transactionTypeFrom.add('');
      seqPrefixController.add(TextEditingController(
          text: ''
      ));
      fromController.add(TextEditingController(
          text: ''
      ));
      if(i==0){
        salesPrefix=transactionTypePrefix[i];
        salesFrom=transactionTypeFrom[i];
      }
      else if(i==1){
        salesReturnPrefix=transactionTypePrefix[i];
        salesReturnFrom=transactionTypeFrom[i];
      }
      else if(i==2){
        purchasePrefix=transactionTypePrefix[i];
        purchaseFrom=transactionTypeFrom[i];
      }
      else if(i==3){
        purchaseReturnPrefix=transactionTypePrefix[i];
        purchaseReturnFrom=transactionTypeFrom[i];
      }
      else if(i==4){
        receiptPrefix=transactionTypePrefix[i];
        receiptFrom=transactionTypeFrom[i];
      }
      else if(i==5){
        paymentPrefix=transactionTypePrefix[i];
        paymentFrom=transactionTypeFrom[i];
      }
      else if(i==6){
        expensePrefix=transactionTypePrefix[i];
        expenseFrom=transactionTypeFrom[i];
      }
      else if(i==7){
        stockPrefix=transactionTypePrefix[i];
        stockFrom=transactionTypeFrom[i];
      }
    }
  }
  else{
    List temp=sequenceData.split('~');
    print('temp outside if $temp');
    if(temp.length>7){
      print('inside if greter ${temp.length}');
      temp.removeAt(temp.length-1);
      print('temp inside if $temp');
    }
    print('inside else temp ${temp.length}');
    for(int i=0;i<temp.length;i++){
      List tempSplit=temp[i].toString().split(':');
      print('tempSplit $tempSplit');
      transactionTypePrefix.add(tempSplit[0]);
      transactionTypeFrom.add(tempSplit[1]);
      seqPrefixController.add(TextEditingController(
          text: tempSplit[0]
      ));
      fromController.add(TextEditingController(
          text: tempSplit[1]
      ));
      if(i==0){
        salesPrefix=transactionTypePrefix[i];
        salesFrom=transactionTypeFrom[i];
      }
      else if(i==1){
        salesReturnPrefix=transactionTypePrefix[i];
        salesReturnFrom=transactionTypeFrom[i];
      }
      else if(i==2){
        purchasePrefix=transactionTypePrefix[i];
        purchaseFrom=transactionTypeFrom[i];
      }
      else if(i==3){
        purchaseReturnPrefix=transactionTypePrefix[i];
        purchaseReturnFrom=transactionTypeFrom[i];
      }
      else if(i==4){
        receiptPrefix=transactionTypePrefix[i];
        receiptFrom=transactionTypeFrom[i];
      }
      else if(i==5){
        paymentPrefix=transactionTypePrefix[i];
        paymentFrom=transactionTypeFrom[i];
      }
      else if(i==6){
        expensePrefix=transactionTypePrefix[i];
        expenseFrom=transactionTypeFrom[i];
      }
      else if(i==7){
        stockPrefix=transactionTypePrefix[i];
        stockFrom=transactionTypeFrom[i];
      }
    }
  }
  return;
}