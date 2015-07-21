//
//  SnachItDB.m
//  SnachIt
//
//  Created by Akshay Maldhure on 3/20/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import "SnachItDB.h"
#import "AddressDetails.h"
#import "PaymentDetails.h"
#import "SnachItAddressInfo.h"
#import "SnachItPaymentInfo.h"
#import "global.h"

@interface SnachItDB()

@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;
@end


@implementation SnachItDB

static SnachItDB *_database;

+ (SnachItDB*)database {
    _database=nil;
        _database = [[SnachItDB alloc] init];
    return _database;
}

- (id)init {
    self = [super init];
    if (self ) {
        NSString *dbFilename=CURRENTDB;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        
        // Keep the database filename.
        self.databaseFilename = dbFilename;
        
        // Copy the database file into the documents directory if necessary.
        [self copyDatabaseIntoDocumentsDirectory];
         NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
        
        if (sqlite3_open([databasePath UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }
        if (sqlite3_open([databasePath UTF8String], &_database) == SQLITE_OK){
            
        }
    }
    return self;
}

#pragma mark - Private method implementation

-(void)copyDatabaseIntoDocumentsDirectory{
    // Check if the database file exists in the documents directory.
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        // The database file does not exist in the documents directory, so copy it from the main bundle now.
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        
        // Check if any error occurred during copying and display it.
        if (error != nil) {
            //NSLog(@"%@", [error localizedDescription]);
        }
    }
}


- (void)dealloc {
    sqlite3_close(_database);
    [super dealloc];
}

-(int)getSnachTime:(int)snachid UserId:(NSString*)userId SnoopTime:(int)snooptime{
    // Form the query.
    NSString *query = [NSString stringWithFormat:@"select * from snachtimes where snachid=%d and userid=%@ ",snachid,userId];
    sqlite3_stmt *statement;
    int time=0;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            int snooptime = sqlite3_column_int(statement, 3);
            time=snooptime;
        }
        else{
            time=snooptime;
        }
    }
    else{
        time=snooptime;
    }
    sqlite3_finalize(statement);
    sqlite3_close(_database);
    return time;
}
-(BOOL)logtime:(NSString*)userid SnachId:(int)snachid SnachTime:(int)time{
   const char *query = "insert into snachtimes(snachid, userid, snachtime) values(?,?,?)";
    BOOL status;
    // Execute the query.
    sqlite3_stmt *statement = NULL;
    
    if (sqlite3_prepare_v2(_database, query, -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"prepare failed: %s", sqlite3_errmsg(_database));
        
    }
    [self bindString:[NSString stringWithFormat:@"%d",snachid] column:1 statement:statement];
    [self bindString:userid column:2 statement:statement];
    [self bindString:[NSString stringWithFormat:@"%d",time] column:3 statement:statement];
    
    if (sqlite3_step(statement) == SQLITE_DONE) {
        NSLog(@"Data Inserted %s",query);
        status=true;
    } else {
        NSLog(@"Insert failed: %s", sqlite3_errmsg(_database));
        status=false;
    }
      sqlite3_finalize(statement);
     sqlite3_exec(_database, "COMMIT", 0, 0, 0);
    sqlite3_close(_database);
    
    return status;
}

-(BOOL)updatetime:(NSString*)userid SnachId:(int)snachid SnachTime:(int)time{
    BOOL status;
    sqlite3_stmt *statement = NULL;
    const char *sql = "update snachtimes set snachtime = ? where snachid=? and userid=?";
    
    if (sqlite3_prepare_v2(_database, sql, -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"prepare failed: %s", sqlite3_errmsg(_database));
        
    }
    [self bindString:[NSString stringWithFormat:@"%d",time] column:1 statement:statement];
    [self bindString:[NSString stringWithFormat:@"%d",snachid] column:2 statement:statement];
    [self bindString:userid column:3 statement:statement];
    
    if (sqlite3_step(statement) == SQLITE_DONE) {
       // NSLog(@"Data updated");
        status=true;
    }
    else {
       // NSLog(@"Insert failed: %s", sqlite3_errmsg(_database));
        status=false;
    }
    sqlite3_finalize(statement);
    sqlite3_close(_database);
    return status;
}


- (NSArray *)snachItAddressInfo:(NSString*)userid {
    
    NSMutableArray *retval = [[[NSMutableArray alloc] init] autorelease];
    NSString *query = [NSString stringWithFormat:@"SELECT id, fullName, street, city, state,zip,phone FROM address where userid=%@ order by date_added DESC",userid];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int uniqueId = sqlite3_column_int(statement, 0);
            char *nameChars = (char *) sqlite3_column_text(statement, 1);
            char *cityChars = (char *) sqlite3_column_text(statement, 3);
            char *stateChars = (char *) sqlite3_column_text(statement, 4);
            char *streetChars = (char *) sqlite3_column_text(statement, 2);
            char  *zip =  (char *) sqlite3_column_text(statement, 5);
            char *phoneChars =(char *) sqlite3_column_text(statement, 6);
             NSString *postalcode = [[NSString alloc] initWithUTF8String:zip];
            NSString *name = [[NSString alloc] initWithUTF8String:nameChars];
            NSString *street = [[NSString alloc] initWithUTF8String:streetChars];
            NSString *city = [[NSString alloc] initWithUTF8String:cityChars];
            NSString *state = [[NSString alloc] initWithUTF8String:stateChars];
            NSString *phone = [[NSString alloc] initWithUTF8String:phoneChars];
            SnachItAddressInfo *info = [[SnachItAddressInfo alloc] initWithUniqueId:uniqueId name:name street:street city:city state:state zip:postalcode phone:phone];
            [retval addObject:info];
            [name release];
            [city release];
            [state release];
            [street release];
            [phone release];
            [info release];
        }
        
    }
    sqlite3_finalize(statement);
    sqlite3_close(_database);
    return retval;
    
}

- (NSArray *)snachItPaymentInfo:(NSString*)userid {
    
    NSMutableArray *retval = [[[NSMutableArray alloc] init] autorelease];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM payment where userid=%@ order by date_added DESC",userid];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int uniqueId = sqlite3_column_int(statement, 0);
            char *cardname= (char *) sqlite3_column_text(statement, 1);
            char *cardnumber= (char *) sqlite3_column_text(statement, 2);
           
            char *cardexpdate= (char *) sqlite3_column_text(statement, 3);
            int cardcvv= sqlite3_column_int(statement, 4);
            char *nameChars = (char *) sqlite3_column_text(statement, 5);
            char *streetChars = (char *) sqlite3_column_text(statement, 6);
            char *cityChars = (char *) sqlite3_column_text(statement, 7);
            char *stateChars = (char *) sqlite3_column_text(statement, 8);
            
            char  *zip =  (char *) sqlite3_column_text(statement, 9);
            char *phoneChars =(char *) sqlite3_column_text(statement, 10);
            
            NSString *name = [[NSString alloc] initWithUTF8String:nameChars];
            NSString *street = [[NSString alloc] initWithUTF8String:streetChars];
            NSString *postalcode = [[NSString alloc] initWithUTF8String:zip];
            NSString *city = [[NSString alloc] initWithUTF8String:cityChars];
            NSString *state = [[NSString alloc] initWithUTF8String:stateChars];
            NSString *cardname1 = [[NSString alloc] initWithUTF8String:cardname];
            NSString *cardnumber1 = [[NSString alloc] initWithUTF8String:cardnumber];
            NSString *expdate = [[NSString alloc] initWithUTF8String:cardexpdate];
            
            SnachItPaymentInfo *info = [[SnachItPaymentInfo alloc] initWithUniqueId:uniqueId CardName:cardname1 CardNumber:cardnumber1 CardExpDate:expdate CardCVV:cardcvv name:name street:street city:city state:state zip:postalcode phone:[[NSString alloc] initWithUTF8String:phoneChars]];
            
            [retval addObject:info];
            [name release];
            [city release];
            [state release];
            [street release];
            [cardname1 release];
            [cardnumber1 release];
            [expdate release];
            [info release];
        }
        
    }
    sqlite3_finalize(statement);
    sqlite3_close(_database);
    return retval;
}

-(NSDictionary*)addPayment:(NSString *)cardName CardNumber:(NSString *)cardNumber CardExpDate:(NSString *)expdate CardCVV:(NSString *)cvv Name:(NSString *)name Street:(NSString *)street City:(NSString *)city State:(NSString *)state Zip:(NSString *)zip Phone:(NSString *)phone UserId:(NSString*)userid{
    
    NSMutableDictionary *info=[[NSMutableDictionary alloc] init];
    BOOL status=false;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSDate *currentdatetime = [[NSDate alloc] init];
    [df setDateFormat:@"dd-MM-yyyy hh:mm:ss"];
    const char *query = "insert into payment(cardnumber,cardname,expdate,cvv,fullName,street,city,state,zip,phone,date_added,userid) values(?,?,?,?,?,?,?,?,?,?,?,?)";
    
    sqlite3_stmt *statement = NULL;
    
    if (sqlite3_prepare_v2(_database, query, -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"prepare failed: %s", sqlite3_errmsg(_database));
        
    }
    [self bindString:cardName column:1 statement:statement];
    [self bindString:cardNumber column:2 statement:statement];
    [self bindString:expdate column:3 statement:statement];
    [self bindString:cvv column:4 statement:statement];
    [self bindString:name column:5 statement:statement];
    [self bindString:street column:6 statement:statement];
    [self bindString:city column:7 statement:statement];
    [self bindString:state column:8 statement:statement];
    [self bindString:zip column:9 statement:statement];
    [self bindString:phone column:10 statement:statement];
    [self bindString:[df stringFromDate:currentdatetime] column:11 statement:statement];
    currentdatetime=nil;
    [self bindString:userid column:12 statement:statement];
    if (sqlite3_step(statement) == SQLITE_DONE) {
       // NSLog(@"Data Inserted");
        status=true;
    } else {
        //NSLog(@"Insert failed: %s", sqlite3_errmsg(_database));
        status=false;
    }
    sqlite3_finalize(statement);
    sqlite3_close(_database);
    [info setObject:[NSString stringWithFormat:@"%d",status] forKey:@"status"];
    [info setObject:[NSString stringWithFormat:@"%lld",sqlite3_last_insert_rowid(_database)] forKey:@"lastrow"];
    return info;
}

-(NSDictionary*)updatePayment:(NSString *)cardName CardNumber:(NSString *)cardNumber CardExpDate:(NSString *)expdate CardCVV:(NSString *)cvv Name:(NSString *)name Street:(NSString *)street City:(NSString *)city State:(NSString *)state Zip:(NSString *)zip Phone:(NSString *)phone UserId:(NSString*)userid RecordId:(NSString*)recordId{
    
    NSMutableDictionary *info=[[NSMutableDictionary alloc] init];
    BOOL status=false;
   
    const char *query = "update payment set cardnumber=?,cardname=?,expdate=?,cvv=?,fullName=?,street=?,city=?,state=?,zip=?,phone=? where userid=? and id=?";
    
    sqlite3_stmt *statement = NULL;
    
    if (sqlite3_prepare_v2(_database, query, -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"prepare failed: %s", sqlite3_errmsg(_database));
        
    }
    [self bindString:cardNumber column:2 statement:statement];
    [self bindString:cardName column:1 statement:statement];
    [self bindString:expdate column:3 statement:statement];
    [self bindString:cvv column:4 statement:statement];
    [self bindString:name column:5 statement:statement];
    [self bindString:street column:6 statement:statement];
    [self bindString:city column:7 statement:statement];
    [self bindString:state column:8 statement:statement];
    [self bindString:zip column:9 statement:statement];
    [self bindString:phone column:10 statement:statement];
    [self bindString:userid column:11 statement:statement];
    [self bindString:recordId column:12 statement:statement];

    if (sqlite3_step(statement) == SQLITE_DONE) {
        // NSLog(@"Data Inserted");
        status=true;
    } else {
        //NSLog(@"Insert failed: %s", sqlite3_errmsg(_database));
        status=false;
    }
    sqlite3_finalize(statement);
    sqlite3_close(_database);
    [info setObject:[NSString stringWithFormat:@"%d",status] forKey:@"status"];
    [info setObject:[NSString stringWithFormat:@"%lld",sqlite3_last_insert_rowid(_database)] forKey:@"lastrow"];
    return info;
}



-(NSDictionary*)addAddress:(NSString*)name Street:(NSString*)street City:(NSString*)city State:(NSString*)state Zip:(NSString*)zip Phone:(NSString*)phone UserId:(NSString*)userid{
    NSMutableDictionary *info=[[NSMutableDictionary alloc] init];
    BOOL status=false;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSDate *currentdatetime = [[NSDate alloc] init];
    [df setDateFormat:@"dd-MM-yyyy hh:mm:ss"];
     const char *query = "insert into address(fullName,street,city,state,zip,phone,date_added,userid) values(?,?,?,?,?,?,?,?)";
    sqlite3_stmt *statement = NULL;
    
    if (sqlite3_prepare_v2(_database, query, -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"prepare failed: %s", sqlite3_errmsg(_database));
        
    }
    [self bindString:name column:1 statement:statement];
    [self bindString:street column:2 statement:statement];
    [self bindString:city column:3 statement:statement];
    [self bindString:state column:4 statement:statement];
    [self bindString:zip column:5 statement:statement];
    [self bindString:phone column:6 statement:statement];
    [self bindString:[df stringFromDate:currentdatetime] column:7 statement:statement];
    [self bindString:userid column:8 statement:statement];
    if (sqlite3_step(statement) == SQLITE_DONE) {
        //NSLog(@"Data Inserted");
        status=true;
    } else {
       // NSLog(@"Insert failed: %s", sqlite3_errmsg(_database));
        status=false;
    }
    sqlite3_finalize(statement);
    sqlite3_close(_database);
    [info setObject:[NSString stringWithFormat:@"%d",status] forKey:@"status"];
    [info setObject:[NSString stringWithFormat:@"%lld",sqlite3_last_insert_rowid(_database)] forKey:@"lastrow"];
    return info;
}
-(NSDictionary*)updateAddress:(NSString*)name Street:(NSString*)street City:(NSString*)city State:(NSString*)state Zip:(NSString*)zip Phone:(NSString*)phone UserId:(NSString*)userid RecordId:(NSString *)recordid{
    NSMutableDictionary *info=[[NSMutableDictionary alloc] init];
    BOOL status=false;
   
    const char *query = "update address set fullName=?,street=?,city=?,state=?,zip=?,phone=? where userid=? and id=?";
    sqlite3_stmt *statement = NULL;
    
    if (sqlite3_prepare_v2(_database, query, -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"prepare failed: %s", sqlite3_errmsg(_database));
        
    }
    [self bindString:name column:1 statement:statement];
    [self bindString:street column:2 statement:statement];
    [self bindString:city column:3 statement:statement];
    [self bindString:state column:4 statement:statement];
    [self bindString:zip column:5 statement:statement];
    [self bindString:phone column:6 statement:statement];
    [self bindString:userid column:7 statement:statement];
    [self bindString:recordid column:8 statement:statement];
    if (sqlite3_step(statement) == SQLITE_DONE) {
        //NSLog(@"Data Inserted");
        status=true;
    } else {
        // NSLog(@"Insert failed: %s", sqlite3_errmsg(_database));
        status=false;
    }
    sqlite3_finalize(statement);
    sqlite3_close(_database);
    [info setObject:[NSString stringWithFormat:@"%d",status] forKey:@"status"];
    [info setObject:[NSString stringWithFormat:@"%lld",sqlite3_last_insert_rowid(_database)] forKey:@"lastrow"];
    return info;
}



- (PaymentDetails *)snachItPaymentDetails:(int)uniqueId UserId:(NSString*)userid {
    PaymentDetails *retval = nil;
    NSString *query = [NSString stringWithFormat:@"SELECT id,cardnumber,cardname,expdate,cvv,fullName,street, city, state, zip, phone FROM payment WHERE id=%d and userid=%@", uniqueId,userid];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int uniqueId = sqlite3_column_int(statement, 0);
            char *cardnumber = (char *) sqlite3_column_text(statement, 2);
            char *cardname = (char *) sqlite3_column_text(statement, 1);
            char *expdate = (char *) sqlite3_column_text(statement, 3);
            int cvv = sqlite3_column_int(statement, 4);
            char *nameChars = (char *) sqlite3_column_text(statement, 5);
            char *streetChars = (char *) sqlite3_column_text(statement, 6);
            char *cityChars = (char *) sqlite3_column_text(statement, 7);
            char *stateChars = (char *) sqlite3_column_text(statement, 8);
            char *zip = (char *) sqlite3_column_text(statement, 9);
            char *phone = (char *) sqlite3_column_text(statement, 10);
            
            
            retval = [[PaymentDetails alloc] initWithUniqueId:uniqueId CardName:[[NSString alloc] initWithUTF8String:cardname] CardNumber:[[NSString alloc] initWithUTF8String:cardnumber] CardExpdate:[[NSString alloc] initWithUTF8String:expdate] CardCVV:cvv name:[[NSString alloc] initWithUTF8String:nameChars] address:[[NSString alloc] initWithUTF8String:streetChars] city:[[NSString alloc] initWithUTF8String:cityChars] state:[[NSString alloc] initWithUTF8String:stateChars] zip:[[NSString alloc] initWithUTF8String:zip] phoneNumber:[[NSString alloc] initWithUTF8String:phone]];
            
            break;
        }
        

    }
    sqlite3_finalize(statement);
    sqlite3_close(_database);
    return retval;
}



- (AddressDetails *)snachItAddressDetails:(int)uniqueId UserId:(NSString*)userid{
    AddressDetails *retval = nil;
    NSString *query = [NSString stringWithFormat:@"SELECT id, fullName,street, city, state, zip, phone FROM address WHERE id=%d and userid=%@", uniqueId,userid];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int uniqueId = sqlite3_column_int(statement, 0);
            char *nameChars = (char *) sqlite3_column_text(statement, 1);
            char *streetChars = (char *) sqlite3_column_text(statement, 2);
            char *cityChars = (char *) sqlite3_column_text(statement, 3);
            char *stateChars = (char *) sqlite3_column_text(statement, 4);
            char *zip =  (char *) sqlite3_column_text(statement, 5);
            char *phone = (char *) sqlite3_column_text(statement, 6);
            
            NSString *name = [[NSString alloc] initWithUTF8String:nameChars];
            NSString *street=[[NSString alloc] initWithUTF8String:streetChars];;
            NSString *city = [[NSString alloc] initWithUTF8String:cityChars];
            NSString *state = [[NSString alloc] initWithUTF8String:stateChars];
            NSString *postal = [[NSString alloc] initWithUTF8String:zip];
            
            retval = [[[AddressDetails alloc] initWithUniqueId:uniqueId name:name address:street city:city state:state zip:postal phoneNumber:[[NSString alloc] initWithUTF8String:phone]] autorelease];
            
            [name release];
            [city release];
            [state release];
            [street release];
            break;
        }
        
            }
    sqlite3_finalize(statement);
    sqlite3_close(_database);

    return retval;
}

-(BOOL)deleteRecordFromPayment:(int)uniqueId Userid:(NSString*)userid{
    
        const char *query= "Delete from payment where id=? and userid=?";
    sqlite3_stmt *statement;
    BOOL status=false;
    @try{
    if (sqlite3_prepare_v2(_database, query, -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"prepare failed: %s", sqlite3_errmsg(_database));
        
    }
    if (sqlite3_prepare_v2(_database, query, -1, &statement, nil) == SQLITE_OK) {
        [self bindString:[NSString stringWithFormat:@"%d",uniqueId] column:1 statement:statement];
        [self bindString:userid column:2 statement:statement];
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"Data deleted %s",query);
            status=true;
        } else {
            NSLog(@"Delete failed: %s", sqlite3_errmsg(_database));
            status=false;
        }
    }
        sqlite3_finalize(statement);
        sqlite3_close(_database);
    }
    @catch(NSException *e){}
   
    return status;
}

-(BOOL)deleteRecordFromAddress:(int)uniqueId Userid:(NSString*)userid{

    const char *query= "Delete from address where id=? and userid=?";
    sqlite3_stmt *statement;
    BOOL status=false;
    @try{
    if (sqlite3_prepare_v2(_database, query, -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"prepare failed: %s", sqlite3_errmsg(_database));
        
    }
    if (sqlite3_prepare_v2(_database, query, -1, &statement, nil) == SQLITE_OK) {
        [self bindString:[NSString stringWithFormat:@"%d",uniqueId] column:1 statement:statement];
        [self bindString:userid column:2 statement:statement];
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"Data deleted %s",query);
            status=true;
        } else {
            NSLog(@"Delete failed: %s", sqlite3_errmsg(_database));
            status=false;
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(_database);
    }
    @catch(NSException *e){}
   
    return status;
}
-(BOOL)bindString:(NSString *)value column:(NSInteger)column statement:(sqlite3_stmt *)statement
{
    if (value) {
        if (sqlite3_bind_text(statement, (int)column, [value UTF8String], -1, SQLITE_TRANSIENT) != SQLITE_OK) {
            sqlite3_finalize(statement);
            return NO;
        }
    } else {
        if (sqlite3_bind_null(statement, (int)column) != SQLITE_OK) {
            sqlite3_finalize(statement);
            return NO;
        }
    }
    
    return YES;
}
@end
