//
//  AppController.m
//  PicoPico
//
//  Created by hkrn on 09/02/11.
//  Copyright 2009 hkrn. All rights reserved.
//

#import "AppController.h"

@implementation AppController

@synthesize status;

- (void)didCompile:(NSNotification *)notification
{
    self.status = NSLocalizedString(@"Compiled", @"");
    NSLog(@"%@", self.status);
}

//- (void)didResume:(NSNotification *)notification
//{
//    self.status = NSLocalizedString(@"Resumed", @"");
//    NSLog(@"%@", self.status);
//}

- (id)init
{
    self = [super init];
    if (self != nil) {
        engine = [[MMLEngine alloc] init];

        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self
                   selector:@selector(didCompile:)
                       name:MMLEngineDidCompile
                     object:nil];
//        [center addObserver:self
//                   selector:@selector(didBuffer:)
//                       name:MMLSequencerDidBuffer
//                     object:nil];
//        [center addObserver:self
//                   selector:@selector(didStop:)
//                       name:MMLSequencerDidStop
//                     object:nil];
//        [center addObserver:self
//                   selector:@selector(didResume:)
//                       name:MMLEngineDidResume
//                     object:nil];
    }
    return self;
}

- (void)dealloc
{
    [engine release];
    [super dealloc];
}

- (void)update
{
    if (![engine m_compiling] && [engine.m_string length] > 0) {
        [engine.m_sequencer update];
		return;
    }
}

- (IBAction)play:(id)sender
{
//    if ([engine isPlaying]) {
//        return;
//    }

//	// HCF
//    NSString *mmlText = @"@F1,20,100,111"
//	"@E2,0,20,0,0"
//	"@1 L16O3 R4"
//	"/:/:4 D>A<E>DAED <A<E>EDA>EDA<:/D>A<E>A<:/"
//	";"
//	"@E1,0,10,0,0"
//	"@F1,40,40,127"
//	"@E2,0,30,0,0"
//	"@1O4 L16CCCCL4/:8CCCC:/"
//	";"
//	"@4V8R4R1R1R1R1"
//	"L8/:16@P48@E1,0,5,0,0C @P80@E1,0,30,0,0C :/"
//	;
	
	// Bach 小フーガ
//    NSString *mmlText = @""
//	"@2@E1,1,32,110,4 t90 v15"   
//	"/:4"
//	"l8q15 o6" 
//	"g4<d4>b-4.agb-agf+aq12d4"
//	"q15gdadb-a16g16ad l16 g8dga8dab-8agad<dc>b-agb-agf+agdgab-<cde"
//	":/;"
//
//	"@2@E1,1,32,110,4 t90 v3r8."
//	"/:4"
//	"l8q15 o6 g4<d4>b-4.agb-agf+aq12d4"
//	"q15gdadb-a16g16ad l16 g8dga8dab-8agad<dc>b-agb-agf+agdgab-<cde"
//	":/;"
//	;

	// DPCM
	NSString *mmlText = @""
	"$h =@7   @e1,0,6,0,0o0c ;"
	"$c =@7   @e1,0,7,0,0o0c+;"
	"$b =@9-0 o1d+;"
	"$s =@9-1 o1d+;"
	"$ta=@9-2 o1d+;"
	"$tb=@9-2 o1d ;"
	"$tc=@9-2 o1c+;"
	
	"T110"
	/* --- CH1:PL1 --- */
	"@e1,0,16,64,0 l16 q16 @5@w1 v4 o4"
	"c2l64/:a&b&<c&d&e&f&g&:/>>l16 q8"
	"/:4/:/:c<c>b-<c>/cgb-g://>b-<b-ag:/<<e64&f32.d+c&c->>:/;"
	
	/* --- CH2:PL2 --- */
	"@e1,0,16,0,0 l16 q10 @5@w2 v4 o4"
	"r2/:14r64:/"
	"/:8fgggf+efefgggfedc:/;"
	
	/* --- CH3:TRIANGLE --- */
	"@e1,0,0,128,0 l16 @6 v15 o3 q16"
	"g2l64/:a&b&<c&d&e&f&g&:/>>l16"
	"q12/:8/:3c<ccc>:/>b-<<fgb->:/;"
	
	/* --- CH4:NOISE --- */
	"@e1,0,0,128,0 l16 v5 o3 q12"
	"$c2/:14r64:/"
	"/:4/:7$c$h$h$h:/$c$c$c$c:/;"
	
	
	/* --- CH5:DPCM --- */
	"@e1,0,0,256,0 l16 v15"
	"$tb4$tc4/:7$s32:/"
	"/:4"
	"/:$b8$s8$b8$s8/$b8$s8$b$ta$tb$tc:/"
	"$b$ta32$ta32$ta$ta$tb$tb$tc$tc"
	":/"
	";"
	
	
	/* Standard 1 Kick 1 */
"#WAV9 0,0,0,QTB7Ar9hBv5gkk0cHuON/5jz+fz4///47x/8UnBAAQAAAAAAAAAAAAAAAAAAAAAA8P/3/////3//////////////////f2AwAAAGAAY0AAHIAAAAAAAAAAAAAAAAAIDu7t57997t89de+/GnD3/iT33CWWl4mBiaCAfggRAYJRQOBoVl6OB4FE9La5bLyi2blavROZ2qw2pLK3U8yk11mk7TqqqqqipVVVVVVaqqqlJVVaqqSlVVqaoqVVWlqkpVpapUVapKVaUqValKVapSlSpVqlSpUqVKAAAAAAAAAAAA"
	
	/* Standard 1 Snare 1 */
"#WAV9 1,0,0,6Q/x/zgAAAAA/3/8//8/gA8ctqSSAAAAANj/D7/gwEP//+///y8pAcAAHvInAAAA2NrWtv/////P4AGA95w5AcAIABBC9FH/9+8YgP/v/v+HPYI8xEAeAAAA5jznyME9/v85/v/x6IzAAYBfR3wAAgSDiXvsjP/Y/7n/wB/z+FDwBiAYDABhxh/99x4PtMjA//vnj0cQA8PjiWLkCHAYgMfDn///z4+HJOOGkGPYM+PBMGbIAeM5/3GOM+AHhvffcz8Ti4EgDsAj+HPwwZ+BH909nsV441Ec8gXHMZ/hbWDCYCJn8Mdyzu2nceKYcrucORwoowBqr5033lyRIyaHcLLPrZM3alg01hmZuZCH4QytF+ztjn7RwRMxccRsB48vMfoojz70DdyIBzIni2PfjBcb2mHHicdBHeCJ7374xeyAxogzNg+btBiS5Rz3i3snHorJQN0cel5ycs2YJiIvFO44/qyYucx8yHkcmWPm4QseHMcC8SB7jRNXPBwPfJ/zix+nDxDGwXE8LoNDjnHGJT4yn/tYbwxDbjnuUB1jCh0nOOD5Mfe4Q7zBcRzXqW0Jx8Q84JerqvI0p5AxGkxZfXD0nenig89MejwajuODeCxgYQxbdXx8r6N7yHFcqHqYKsN4cczwmEONJz7yY+szqngwBlz4sDu35iPPGCeGdqSKcpQ52MN8sYbv88w5LnhCi4phD4OHi5Irz2jvuKo9juPSSAanCzaHB58cVWXqjrma6pSs6CDnxlEzrqrlcriqZqkbjVqqQjgrKtxV5TNvhqslz7JyyZmoilNSYaF6cbW1lGfbDk92huKowkhnKe3ktDJupjE5T+tmZmZmZmZmZmY="
	
	/* High Tom 1 */
"#WAV9 2,0,0,wfnjjmD4gBFCjJ3f/M///wcRIAyEARLDgGDh/P///+N87+wDAgwIuQBDsMHI//zE/23/j98ABhwAgAB8zNoZj5z8e76z5n+Vc24SBAYSgqGJoKLT0l+/394etruDVzqKMIIihBKFUe5M3mtp2+mrrt08u2o5VoIgEiMKxJRSqubO17f3qe1Wqa2yWtqYSJEEhIhUVWq1nF21q75rte3dWtayTFIRRIoAUVJJSbXV3ezuu3Zb29qaWp0SJUmCUkCUREmrqqxq67rut7192yq7UpVIIkGCCCVJJVWmtdXtXtvb27ZmtZSmVDJFWZGEIlSVVKVaq8raXettXde2VlUlVZKSklKSFKmSUrVVq2rbaq222taqqpWqqpZKmSqpUhKlklSqqrLatlrbra2tWlVVK6tUJamkSpKklClV1VRVraptq93abmtVrZaqVCkliRKSRFKkqqpa167b3rZta9VWVZkmlVKSpEiEpKRKVbVaa21rt62t3bZV1aqUSlIkKZEkUVKprKq1Wtu6tm3bttaqqlIpKaWUSlJKSSlVq6q11qqpVataq6q1Vk2rqlRZpVKqSpIqU6pKVVVVq1azWqur2qpVVbWqKlWlUqqSlEpVqarSVE2rslqttq3aWqtVVVWVKZVSqpRSUlKlVFVWtWptW62t1lqr1aqqqVKlFKmURCmlVKpqVq3WWq21tdpWW6tVVZUqKUkqSUlSpVRVVTWrta211qqtVbOqalWpSqWUqqRSSqlKVVlVrapVq9Zaq1qtVquqqlKVKlWqUkollapKVVWrWrVatVarqlatalXVVFVVKpWqUkpKKZWqqqpatVq11bba1taqpamqlFJKKklKUqmUmWrVqq1tra1aa61aVVWVKlVSqlJKKVWpUpVVVa1atVWrtarVWrWqqqpSlVKpVFIpVapKNVXVqlVrtdWq1qpaVVWqqkqVqkqVSqWq1FJNq6qaZVZVtapWq6pVraqaqqpKlapKpVIpVaWqqqpq1arVWq1q1apWVVWVqlKpqpRSpUpVVappplW1WrVWrarWrFZVVVWqVKkqlVSlylKVpapqVbVqtVaratWqWlVVlapUqlIplapSVVVVVdWqVq1qtapqVbWqqqpKVaqqVKlSpapMTVXVrGa1WrWqqqqqqqqqqqqqqqrKVFWaqspUVVWqZlZV1aqqVVWrqqpqVVXVVFVVVVWqqqqqqlRVVVVVqaqqqqpSVVVVVaWqqqqqSlVVVaqqSlVVqaoqVVWlqqpUVamqVJWqSlWpqlSlKlWpSlWqUqVKlSpVqlSpAAAAAAAAAAA="
	;	
	
    self.status = NSLocalizedString(@"Start compiling", @"");
    NSLog(@"%@", self.status);
    [engine play:mmlText];
}

//- (IBAction)togglePlay:(id)sender
//{
//    if ([engine isPlaying]) {
//        [engine pause];
//        [self toggleStateOff];
//    }
//    else {
//        [self play:sender];
//    }
//}

//- (IBAction)stop:(id)sender
//{
//    [engine stop];
//}

//- (IBAction)setVolume:(id)sender
//{
////    engine.masterVolume = [(NSTextField *)sender intValue];
//}

@end
