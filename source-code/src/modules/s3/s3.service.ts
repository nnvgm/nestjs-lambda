import { Injectable, InternalServerErrorException } from '@nestjs/common';
import { S3Client, GetObjectCommand } from '@aws-sdk/client-s3';

@Injectable()
export class S3Service {
  private s3Client: S3Client;

  constructor() {
    this.s3Client = new S3Client({
      region: process.env.AWS_REGION || 'ap-southeast-1',
    });
  }

  async getObject(bucketName: string, s3Key: string) {
    try {
      const getObjectCmd = new GetObjectCommand({
        Bucket: bucketName,
        Key: s3Key,
      });
      const response = await this.s3Client.send(getObjectCmd);
      return response.Body.transformToString();
    } catch (error) {
      throw new InternalServerErrorException({
        message: error.message,
        code: 'INTERNAL_SERVER_ERROR',
      });
    }
  }
}
