
import 'package:scoped_model/scoped_model.dart';

import 'DataStorageService.dart';
import 'SharedService.dart';



class MainScopeModel extends Model
	with
		DataStorageService,
		SharedService
{
}