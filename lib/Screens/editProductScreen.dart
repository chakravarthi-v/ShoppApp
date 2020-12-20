import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName='/EditProduct';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode=FocusNode();
  final _descriptionFocusNode=FocusNode();
  var _imageUrlController=TextEditingController();
  final _imageUrlFocusNode=FocusNode();
  final _form=GlobalKey<FormState>();
  var _editedProduct=Product(id:null,title:'',price:0,description:'',imageUrl: '',);
  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    super.dispose();
  }
  var _initValues={'title':'','description':'','price':'','imageUrl':'',};
  bool _isInit=true;
  bool _isLoading=false;
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }
  @override
  void didChangeDependencies() {
    if(_isInit){
     final productId=ModalRoute.of(context).settings.arguments as String;
     if(productId!=null){
       _editedProduct=Provider.of<Products>(context,listen: false).findById(productId);
       _initValues={'title':_editedProduct.title,'description':_editedProduct.description,
         'price':_editedProduct.price.toString(),'imageUrl':''
       };
       _imageUrlController.text=_editedProduct.imageUrl;
     }
    }
    _isInit=false;
    super.didChangeDependencies();
  }
  void _updateImageUrl(){
    if(!_imageUrlFocusNode.hasFocus){
      setState(() {});
    }
  }
  
  Future<void> _saveForm() async{
    final isValid=_form.currentState.validate();
    if(!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading=true;
    });

    if(_editedProduct.id!=null){
      try {
        await Provider.of<Products>(context, listen: false).updateProduct(
            _editedProduct.id, _editedProduct);
        print(1);
      }
      catch(error){
        await showDialog<Null>(context: context,builder: (ctx)=>
            AlertDialog(title: Text('An error occurred!'),content: Text('Something went wrong'),
              actions: <Widget>[
                FlatButton(child: Text('okay'),onPressed: (){
                  Navigator.of(ctx).pop();
                },)
              ],));
      }
      print(2);
    }
    else{
      try{
        await Provider.of<Products>(context,listen: false).addProduct(_editedProduct);
      }
      catch(error){
        await showDialog<Null>(context: context,builder: (ctx)=>
            AlertDialog(title: Text('An error occurred!'),content: Text('Something went wrong'),
              actions: <Widget>[
                FlatButton(child: Text('okay'),onPressed: (){
                  Navigator.of(ctx).pop();
                },)
              ],));
      }
      /*finally{
        setState(() {
          _isLoading=false;
        });
        Navigator.of(context).pop();
      }*/

    }
    setState(() {
      print('out');
      _isLoading=false;
    });
    Navigator.of(context).pop();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Edit Product'),actions: <Widget>[
      IconButton(icon: Icon(Icons.save),
      onPressed:_saveForm,)
    ],),
      body:_isLoading?Center(child: CircularProgressIndicator(),):Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(key:_form,child: ListView(children: <Widget>[
            TextFormField(decoration: InputDecoration(labelText: 'Title'),
              initialValue: _initValues['title'],
              textInputAction: TextInputAction.next,
              validator: (value) {
              if(value.isEmpty){
                return 'Please provide a value';
              }
              return null;
            },
              onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(_priceFocusNode);},
              onSaved: (newValue) {
              _editedProduct=Product(id:_editedProduct.id,title: newValue,price: _editedProduct.price,description: _editedProduct.description,imageUrl: _editedProduct.imageUrl,isFavourite: _editedProduct.isFavourite);
              },),
            TextFormField(decoration: InputDecoration(labelText: 'Price'),
            initialValue: _initValues['price'],
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            focusNode: _priceFocusNode,
            validator: (value) {
              if(value.isEmpty){
                return 'Please enter a price';
              }
              if(double.tryParse(value)==null){
                return 'Please enter a vali number';
              }
              if(double.parse(value)<=0){
                return 'Please enter a number greater than zero';
              }
              return null;
            },
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(_descriptionFocusNode);},
            onSaved: (newValue) {
              _editedProduct=Product(id:_editedProduct.id,title: _editedProduct.title,price:double.parse(newValue),description: _editedProduct.description,imageUrl: _editedProduct.imageUrl,isFavourite: _editedProduct.isFavourite);
            },
          ),
            TextFormField(decoration: InputDecoration(labelText: 'Description'),
            initialValue: _initValues['description'],
            textInputAction: TextInputAction.next,
            maxLines: 3,
            keyboardType: TextInputType.multiline,
            validator: (value) {
              if(value.isEmpty){
                return 'Please enter a description';
              }
              if(value.length<10){
                return 'Should be atleast 10 characters long.';
              }
              return null;
            },
            focusNode: _descriptionFocusNode,
            onSaved: (newValue) {
              _editedProduct=Product(id:_editedProduct.id,title:_editedProduct.title,price: _editedProduct.price,description:newValue,
                  imageUrl: _editedProduct.imageUrl,isFavourite: _editedProduct.isFavourite);
            },
          ),
            Row(crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(width: 100,height: 100,margin: EdgeInsets.only(top: 8,right: 10),
              decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.grey)),
                child: _imageUrlController.text.isEmpty?Text('Enter a URL'):
              FittedBox(child: Image.network(_imageUrlController.text),fit: BoxFit.cover,)),
              Expanded(
                child: TextFormField(decoration: InputDecoration(labelText: 'Image URL'),
                //initialValue: _initValues['imageUrl'],
                keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              focusNode: _imageUrlFocusNode,
              controller: _imageUrlController,
              validator: (value){
                if(value.isEmpty){
                  return 'Please enter an image URL';
                }
                if(!value.startsWith('http')&&!value.startsWith('https')){
                  return 'Please enter a valid URL';
                }
                /*if(!value.endsWith('.png')&&!value.endsWith('.jpg')&&!value.endsWith('.jpeg')){
                  return 'Please enter a valid Image URL';
                }*/
                return null;
              },
              onFieldSubmitted: (value) {_saveForm();},
              onEditingComplete: (){
                setState(() {});
              },
                onSaved: (newValue) {
                  _editedProduct=Product(id:_editedProduct.id,title:_editedProduct.title,price: _editedProduct.price,description: _editedProduct.description,imageUrl:newValue,isFavourite: _editedProduct.isFavourite);
                },
              ),
            )
          ],),
        ],),),
      ),
    );  }
}
