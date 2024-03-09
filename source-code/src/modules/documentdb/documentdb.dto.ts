import { ApiProperty } from '@nestjs/swagger';

export class CreateExampleDto {
  @ApiProperty({
    type: String,
    example: 'example text',
    required: true,
  })
  text: string;
}
