#import "playView.h"
#import "AppDelegate.h"

@implementation playView
@synthesize left;
@synthesize right;
@synthesize toy;
@synthesize toyPoint;
@synthesize currentPoint;
@synthesize previousPoint;
@synthesize acceleration;
@synthesize petXVelocity;
@synthesize petYVelocity;


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code for toy
    [toy drawAtPoint:toyPoint];
    
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
        // Set the images
        self.left = [UIImage imageNamed:@"walkingLeft.png"];
        self.right = [UIImage imageNamed:@"walkingRight.png"];
        self.toy = [UIImage imageNamed:@"ball.png"];
        
        // Set current point to center of view
        self.currentPoint = CGPointMake((self.bounds.size.width / 2.0f) +
                                        (left.size.width / 2.0f),
                                        (self.bounds.size.height / 2.0f) + (left.size.height / 2.0f));
        
        // Generate a random point for toy
        [self generateToyPoint];
        
        petXVelocity = 0.0f;
        petYVelocity = 0.0f;
    }
    
    return self;
}

-(void) generateToyPoint
{
    CGFloat x = (CGFloat) (arc4random() % (int) self.bounds.size.width);
    CGFloat y = (CGFloat) (arc4random() % (int) self.bounds.size.height);
    
    self.toyPoint = CGPointMake(x,y);
    [toy drawAtPoint:toyPoint];

}

#pragma mark -
-(CGPoint)currentPoint
{
    return currentPoint;
}

-(void)setCurrentPoint:(CGPoint)newPoint
{
    // Update the point
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
        
        CGFloat xAcceleration = secondsSinceLastDraw*petXVelocity*500;
        CGFloat yAcceleration = secondsSinceLastDraw*petYVelocity*500;
        
        self.currentPoint = CGPointMake(self.currentPoint.x + xAcceleration, self.currentPoint.y + yAcceleration);
        
    }
    
    // Update last time with time now
    lastUpdatTime = [[NSDate alloc] init];
}

-(void)success
{
    self.left = [UIImage imageNamed:@"success.png"];
    self.right = [UIImage imageNamed:@"success.png"];
    
    // Play chime sound
    NSString *path = [ [NSBundle mainBundle] pathForResource:@"chime_up" ofType:@"wav"];
    SystemSoundID theSound;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSound);
    AudioServicesPlaySystemSound (theSound);
    
    // Grab points from plist through app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *gameData = [[NSMutableDictionary alloc]
                                     initWithContentsOfFile: [appDelegate gameDataPath]];
    NSNumber *points = [gameData objectForKey:@"points"];

    // Number to increment points
    int change = (arc4random() % 5) + 1;
    
    // Increment points with number 1- 5 and add back to plist
    points = [NSNumber numberWithInt: [points intValue] + change];
    [gameData setObject:points
                 forKey:@"points"];
    [gameData writeToFile:[appDelegate gameDataPath] atomically:NO];
    
    // Change the location of the toy
    [self generateToyPoint];
    
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
        NSLog(@"\nTouches began");
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    NSLog(@"Touch %@", NSStringFromCGPoint(touchPoint));
    NSLog(@"Pet %@", NSStringFromCGPoint(currentPoint));
    NSLog(@"Toy %@", NSStringFromCGPoint(toyPoint));
    
    CGFloat range = 80;     // Define the range
    BOOL toyInRange = NO;   // YES if toy is in range of touch
    BOOL petInRange = NO;   // YES if pet is in range of touch
    
    // Check to see if toy is in range of touch
    if(toyPoint.x < touchPoint.x + range &&
       toyPoint.x > touchPoint.x - range &&
       toyPoint.y < touchPoint.y + range &&
       toyPoint.y > touchPoint.y - range)
    {
        NSLog(@"toy in range");
        toyInRange = YES;
    }
    
    // Check to see if pet is in range of touch
    if(currentPoint.x < touchPoint.x + range &&
       currentPoint.x > touchPoint.x - range &&
       currentPoint.y < touchPoint.y + range &&
       currentPoint.y > touchPoint.y - range)
    {
        NSLog(@"pet in range");
        petInRange = YES;
    }
    
    // Toy is caught!
    if(toyInRange == YES && petInRange == YES)
    {
        [self success];
    }
    
}

@end
