import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/app/constants.dart';
import '../../../../core/data/exception_handler.dart';
import '../../../../core/data/failure.dart';
import '../../domain/entities/service_entities.dart';
import '../../domain/repositories/service_repository.dart';

class ServiceRepositoryImpl extends ServiceRepository {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  Future<Either<Failure, Unit>> addService(
      ServiceEntities serviceEntities) async {
    try {
      await db
          .collection(FireBaseCollection.services)
          .doc("${serviceEntities.companyName}-${serviceEntities.serviceName}")
          .set(serviceEntities.toMap());
      return const Right(unit);
    } catch (e) {
      return Left(ExceptionHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<ServiceEntities>>> getServices(
      String companyName) async {
    try {
      final List<ServiceEntities> services = [];
      final servicesDoc =
          await db.collection(FireBaseCollection.services).get();
      for (var service in servicesDoc.docs) {
        if (service["companyName"] == companyName) {
          final ServiceEntities serviceEntities = ServiceEntities(
            companyName: service["companyName"],
            serviceName: service["serviceName"],
            servicePrice: service["servicePrice"],
            requiredDocuments: service["requiredDocuments"],
          );
          services.add(serviceEntities);
        }
      }
      return Right(services);
    } catch (e) {
      return Left(ExceptionHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteService(
      String companyName, String serviceName) async {
    try {
      final service = db
          .collection(FireBaseCollection.services)
          .doc("$companyName-$serviceName");
      await service.delete();
      return const Right(unit);
    } catch (e) {
      return Left(ExceptionHandler.handle(e).failure);
    }
  }
}
