import { Body, Controller, Post } from '@nestjs/common';
import { CreateExampleDto } from './documentdb.dto';
import { DocumentDbService } from './documentdb.service';

@Controller('documentdb')
export class DocumentDBController {
  constructor(private readonly documentDbService: DocumentDbService) {}

  @Post()
  async create(@Body() createExampleDto: CreateExampleDto) {
    return this.documentDbService.createExample(createExampleDto);
  }
}
