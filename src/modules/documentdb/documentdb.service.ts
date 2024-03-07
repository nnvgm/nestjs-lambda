import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { CreateExampleDto } from './documentdb.dto';
import { Example } from './example.schema';

@Injectable()
export class DocumentDbService {
  constructor(
    @InjectModel(Example.name) private exampleModel: Model<Example>,
  ) {}

  async createExample(createExampleDto: CreateExampleDto) {
    const newRecord = await this.exampleModel.create(createExampleDto);
    return newRecord;
  }
}
