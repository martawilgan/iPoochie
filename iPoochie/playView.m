#import "playView.h"
#import "AppDelegate.h"

@implementation playView
@synthesize timingDate;
@synthesize left;
@synthesize right;
@synthesize item;
@synthesize chosenItem;
@synthesize itemPoint;
@synthesize currentPoint;
@synthesize previousPoint;
@synthesize acceleration;
@synthesize petXVelocity;
@synthesize petYVelocity;


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Grab image data if needed
    if(item == nil)
    {
        // Find which item was chose to play with,set the image and draw
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSMutableDictionary *gameData = [[NSMutableDictionary alloc]
                                         initWithContentsOfFile: [appDelegate gameDataPath]];
        chosenItem = [gameData objectForKey:@"chosenItem"];
        [self generateItemPoint];
        self.item = [UIImage imageNamed:chosenItem];
    }
    
    // Drawing code for toy
    [item drawAtPoint:itemPoint];
    
    // Drawing code for pet in left movement
    if(currentPoint.x<previousPoint.x)
    {
        [left drawAtPoint:currentPoint];
    }
    // Drawing code for pet in right movement
    else
    {
        [right drawAtPoint:currentPoint];
    }
}


-(id) initWithCoder:(NSCoder *)coder
{
    if(self = [super initWithCoder:(NSCoder*)coder])
    {
        // Set the frame size
        //self.frame = CGRectMake(0,20,320,390);
        
        // Set the pet images
        self.left = [UIImage imageNamed:@"walkingLeft.png"];
        self.right = [UIImage imageNamed:@"walkingRight.png"];
        
        // Set current point to center of view
        self.currentPoint = CGPointMake((self.bounds.size.width / 2.0f) +
                                        (left.size.width / 2.0f),
                                        (self.bounds.size.height / 2.0f) + (left.size.height / 2.0f));
        
        // Generate a random point for toy
        [self generateItemPoint];
        
        // Default velocity
        petXVelocity = 0.0f;
        petYVelocity = 0.0f;
        
        timingDate = [NSDate date];
    }
    
    return self;
}

-(void) generateItemPoint
{
    // Generate random point to draw item
    CGFloat x = (CGFloat) (arc4random() % (int) self.bounds.size.width);
    CGFloat y = (CGFloat) (arc4random() % (int) self.bounds.size.height);
    
    self.itemPoint = CGPointMake(x,y);
    
    
    // Make sure point leaves enough space to draw item
    if(itemPoint.x < 0)
    {
        itemPoint.x = 0;
    }
    if(itemPoint.y < 0)
    {
        itemPoint.y = 0;
    }
    if(itemPoint.x > self.bounds.size.width - item.size.width)
    {
        itemPoint.x = self.bounds.size.width - item.size.width;
    }
    if(itemPoint.y > self.bounds.size.height - item.size.height)
    {
        itemPoint.y = self.bounds.size.height - item.size.height;
    }
    
    CGRect itemImageRect = CGRectMake(itemPoint.x, itemPoint.y,
                                      itemPoint.x + item.size.width,
                                      itemPoint.y + item.size.height);
    [self setNeedsDisplayInRect:itemImageRect];

    [item drawAtPoint:itemPoint];

}

#pragma mark -
-(CGPoint)currentPoint
{
    return currentPoint;
}

-(void)setCurrentPoint:(CGPoint)newPoint
{
    // Update the points
    previousPoint = currentPoint;
    currentPoint = newPoint;
    
    // Bounce the pet when it reaches edges of view
    if(currentPoint.x < 0)
    {
        currentPoint.x = 0;
        petXVelocity = -(petXVelocity / 2.0);
    }
    if(currentPoint.y < 0)
    {
        currentPoint.y = 0;
        petYVelocity = -(petYVelocity / 2.0);
    }
    if(currentPoint.x > self.bounds.size.width - left.size.width)
    {
        currentPoint.x = self.bounds.size.width - left.size.width;
        petXVelocity = -(petXVelocity / 2.0);
    }
    if(currentPoint.y > self.bounds.size.height - left.size.height)
    {
        currentPoint.y = self.bounds.size.height - left.size.height;
        petYVelocity = -(petYVelocity / 2.0);
    }
    
    CGRect currentImageRect = CGRectMake(currentPoint.x, currentPoint.y,
                                         currentPoint.x + left.size.width,
                                         currentPoint.y + left.size.height);
    CGRect previousImageRect = CGRectMake(previousPoint.x, previousPoint.y,
                                          previousPoint.x + left.size.width,
                                          currentPoint.y + left.size.width);
    [self setNeedsDisplayInRect:CGRectUnion(currentImageRect, previousImageRect)];
    
}

-(void)update
{
    static NSDate *lastUpdatTime;
    
    if(lastUpdatTime != nil)
    {
        NSTimeInterval secondsSinceLastDraw =
        -([lastUpdatTime timeIntervalSinceNow]);
        
        petYVelocity = petYVelocity + -(acceleration.y*secondsSinceLastDraw);
        petXVelocity = petXVelocity + acceleration.x*secondsSinceLastDraw;
        
        CGFloat xAcceleration = secondsSinceLastDraw*petXVelocity*800;
        CGFloat yAcceleration = secondsSinceLastDraw*petYVelocity*800;
        
        self.currentPoint = CGPointMake(self.currentPoint.x + xAcceleration, self.currentPoint.y + yAcceleration);
        
    }
    
    // Update last time with time now
    lastUpdatTime = [[NSDate alloc] init];
}

-(void)success
{
    // Play chime sound
    NSString *path = [ [NSBundle mainBundle] pathForResource:@"chime_up" ofType:@"wav"];
    SystemSoundID theSound;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSound);
    AudioServicesPlaySystemSound (theSound);
    
    NSString *direction;
    
    // Find how much time before pet caught item
    NSNumber *timeNumber = [NSNumber numberWithDouble:
                            [[NSDate date] timeIntervalSinceDate:self.timingDate]];
    int time = [timeNumber intValue];
    int change; // will hold change for levels and points
    
    // Update the levels
    if(time > 10)
    {
        change = (arc4random() % (20-10)) + 11;
    }
    else
    {
        change = time;
    }
    
    
    // Grab points from plist through app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *gameData = [[NSMutableDictionary alloc]
                                     initWithContentsOfFile: [appDelegate gameDataPath]];
    
    // Update the energry level
    NSNumber *number = [gameData objectForKey:@"energry"];
    int percentage = [number intValue] - change;
    
    // Make sure doen't go below 0
    if(percentage < 0)
    {
        percentage = 0;
    }
    
    [gameData setObject:[NSNumber numberWithInt:percentage]
                 forKey:@"energy"];
    
    // Update the happiness level
    number = [gameData objectForKey:@"happiness"];
    
    // if energy greater than 10 increase happiness
    if(percentage > 10)
    {
        direction = @"up";
        percentage = [number intValue] + change + 1;
    }
    else
    {
        direction = @"down";
        percentage -= 1;
    }
    
    // Make sure it doesn't go above 100 or below 0
    if(percentage > 100)
    {
        percentage = 100;
    }
    if(percentage < 0)
    {
        percentage = 0;
    }

    [gameData setObject:[NSNumber numberWithInt:percentage]
                 forKey:@"happiness"];
    
    // Update health by 1 + or - , if possible
    number = [gameData objectForKey:@"health"];
    
    if ([direction isEqual:@"up"] && ([number intValue] + 1) <= 100)
    {
        [gameData setObject:[NSNumber numberWithInt:[number intValue] + 1]
                     forKey:@"health"];
    }
    if ([direction isEqual:@"down"] && ([number intValue] - 1) >= 0)
    {
        [gameData setObject:[NSNumber numberWithInt:[number intValue] - 1]
                     forKey:@"health"];
    }
    
    NSNumber *points = [gameData objectForKey:@"points"];

    // Number to increment points
    change = (arc4random() % 5) + 1;
    
    switch(change)
    {
        case 1:
            self.left = [UIImage imageNamed:@"1points.png"];
            self.right = [UIImage imageNamed:@"1points.png"];
            break;
        case 2:
            self.left = [UIImage imageNamed:@"2points.png"];
            self.right = [UIImage imageNamed:@"2points.png"];
            break;
        case 3:
            self.left = [UIImage imageNamed:@"3points.png"];
            self.right = [UIImage imageNamed:@"3points.png"];
            break;
        case 4:
            self.left = [UIImage imageNamed:@"4points.png"];
            self.right = [UIImage imageNamed:@"4points.png"];
            break;
        case 5:
            self.left = [UIImage imageNamed:@"5points.png"];
            self.right = [UIImage imageNamed:@"5points.png"];
            break;
    }
    
    // Increment points with number 1- 5 and add back to plist
    points = [NSNumber numberWithInt: [points intValue] + change];
    [gameData setObject:points
                 forKey:@"points"];
    [gameData writeToFile:[appDelegate gameDataPath] atomically:NO];
    
    // Reset the timing
    timingDate = [NSDate date];
    
    // Change the location of the item
    [self generateItemPoint];
    
    // After timer revert images back to pet
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self
                                   selector:@selector(clearSuccess:)
                                   userInfo:nil repeats:NO];
}

// Revert back to left and right images
-(void)clearSuccess:(NSTimer*)inTimer
{
    [inTimer invalidate];
    inTimer = nil;
    
    self.left = [UIImage imageNamed:@"walkingLeft.png"];
    self.right = [UIImage imageNamed:@"walkingRight.png"];
}

// On touch check for success
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Find location of touch
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    CGFloat range = 70;     // Define the range
    BOOL itemInRange = NO;  // YES if item is in range of touch
    BOOL petInRange = NO;   // YES if pet is in range of touch
    
    // Check to see if item is in range of touch
    if(itemPoint.x < touchPoint.x + range &&
       itemPoint.x > touchPoint.x - range &&
       itemPoint.y < touchPoint.y + range &&
       itemPoint.y > touchPoint.y - range)
    {
        itemInRange = YES;
    }
    
    // Check to see if pet is in range of touch
    if(currentPoint.x < touchPoint.x + range &&
       currentPoint.x > touchPoint.x - range &&
       currentPoint.y < touchPoint.y + range &&
       currentPoint.y > touchPoint.y - range)
    {
        petInRange = YES;
    }
    
    // Item is caught!
    if(itemInRange == YES && petInRange == YES)
    {
        [self success];
    }
    
}

@end
