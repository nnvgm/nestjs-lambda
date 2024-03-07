import { Module } from '@nestjs/common';
import {
  MongooseModule,
  MongooseModuleOptions,
  MongooseOptionsFactory,
} from '@nestjs/mongoose';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { S3Module } from './modules/s3/s3.module';
import { DocumentDbModule } from './modules/documentdb/documentdb.module';

class MongooseModuleConfigService implements MongooseOptionsFactory {
  createMongooseOptions(): MongooseModuleOptions {
    return {
      uri: process.env.MONGODB_URI || 'mongodb://127.0.0.1:27017/nestjs-lambda',
    };
  }
}

@Module({
  imports: [
    MongooseModule.forRootAsync({
      useClass: MongooseModuleConfigService,
    }),
    S3Module,
    DocumentDbModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
