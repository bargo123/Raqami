import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'di_container.config.dart';


final di = GetIt.instance;  
@InjectableInit(  
  initializerName: 'init', // default  
  preferRelativeImports: true, // default  
  asExtension: true, // default  
)  
Future<void> configureDependencies() async => await di.init();  