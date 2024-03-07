import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type ExampleDocument = Document<Example>;

@Schema()
export class Example {
  @Prop()
  text: string;
}

export const ExampleSchema = SchemaFactory.createForClass(Example);
