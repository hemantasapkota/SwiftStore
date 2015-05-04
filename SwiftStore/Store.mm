//
//  OLDB.m
//  LevelDBTest
//
//  Created by Hemanta Sapkota on 1/05/2015.
//  Copyright (c) 2015 Hemanta Sapkota. All rights reserved.
//

#import "Store.h"

#include <iostream>
#include <sstream>
#include <string>

#import <leveldb/db.h>

using namespace std;

@implementation Store {
  leveldb::DB *db;
}

- (instancetype) initWithDBName:(NSString *) dbName {
  self = [super init];
  if (self) {
    [self createDB:dbName];
  }
  return self;
}

-(void)createDB:(NSString *) dbName {
  leveldb::Options options;
  options.create_if_missing = true;
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  
  /* Lock Folder */
  NSError *error = nil;
  NSString *dbPath = [paths[0] stringByAppendingPathComponent:dbName];
  /* Create lock file. For some reason, leveldb cannot create the LOCK directory. So we make it. */
  NSString *lockFolderPath = [dbPath stringByAppendingPathComponent:@"LOCK"];
  
  NSFileManager *mgr = [NSFileManager defaultManager];
  if (![mgr fileExistsAtPath:lockFolderPath]) {
    NSURL *url = [NSURL fileURLWithPath:dbPath];
    [mgr createDirectoryAtURL:url withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (error != nil) {
        NSLog(@"%@", error);
        return;
    }
  }
  /* End lock folder */
  
  leveldb::Status status = leveldb::DB::Open(options, [dbPath UTF8String], &self->db);
  if (false == status.ok()) {
      NSLog(@"ERROR: Unable to open/create Open Learning database.");
      std::cout << status.ToString();
  } else {
      NSLog(@"INFO: Open Learning database setup.");
  }
}

-(NSString *)get:(NSString *)key {
  ostringstream keyStream;
  keyStream << key.UTF8String;
  
  leveldb::ReadOptions readOptions;
  string value;
  leveldb::Status s = self->db->Get(readOptions, keyStream.str(), &value);
  
  return [[NSString alloc] initWithUTF8String:value.c_str()];
}

-(void)put:(NSString *)key value:(NSString *)value {
  ostringstream keyStream;
  keyStream << key.UTF8String;
  
  ostringstream valueStream;
  valueStream << value.UTF8String;

  leveldb::WriteOptions writeOptions;
  leveldb::Status s = self->db->Put(writeOptions, keyStream.str(), valueStream.str());
}

-(void)close {
  delete self->db;
}

@end
