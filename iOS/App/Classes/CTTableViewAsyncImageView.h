
@interface CTTableViewAsyncImageView : UIView {
    NSURLConnection *connection;
    NSMutableData *data;
    NSString *urlString;
}

-(void)loadImageFromURL:(NSURL*)url;

@end
