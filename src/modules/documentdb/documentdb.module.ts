import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { DocumentDbService } from './documentdb.service';
import { DocumentDBController } from './documentdb.controller';
import { Example, ExampleSchema } from './example.schema';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: Example.name, schema: ExampleSchema }]),
  ],
  controllers: [DocumentDBController],
  providers: [DocumentDbService],
  exports: [DocumentDbService],
})
export class DocumentDbModule {}
