//
//  DetalleUsuarioSeleccionado.m
//  prototipo.consulta.cedulas
//
//  Created by Habil on 11/02/15.
//  Copyright (c) 2015 Habil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetalleUsuarioSeleccionado.h"
#import "ViewController.h"
@interface DetalleUsuarioSeleccionado ()

@property (weak, nonatomic) IBOutlet UILabel *nombreCarrera;
@property (weak, nonatomic) IBOutlet UILabel *nombreEscuela;
@property (weak, nonatomic) IBOutlet UILabel *numeroCedula;
@property (weak, nonatomic) IBOutlet UILabel *nombreCompleto;
@property (weak, nonatomic) IBOutlet UILabel *nombreGenero;
@property (weak, nonatomic) IBOutlet UILabel *anioExpedicion;
@property (weak, nonatomic) IBOutlet UILabel *tipoCedula;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cerrarModal;

@end

@implementation DetalleUsuarioSeleccionado

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nombreCarrera.text   = [self.detalleUsuarioSeleccionado objectForKey:  @"titulo"];
    self.nombreEscuela.text   = [self.detalleUsuarioSeleccionado objectForKey:  @"desins"];
    self.numeroCedula.text    = [self.detalleUsuarioSeleccionado objectForKey:  @"idCedula"];
    self.nombreCompleto.text  = [self.detalleUsuarioSeleccionado objectForKey:  @"nombre"];
    self.nombreGenero.text    = [self.detalleUsuarioSeleccionado objectForKey:  @"sexo"];
    NSNumber *anioExp         = [self.detalleUsuarioSeleccionado objectForKey:  @"anioreg"];
    self.anioExpedicion.text  = anioExp.stringValue;
    self.tipoCedula.text      = [self.detalleUsuarioSeleccionado objectForKey:  @"tipo"];
}

- (IBAction)tappedCloseModal:(id)sender {
    // assuming your controller has identifier "privacy" in the Storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *privacy = (ViewController*)[storyboard instantiateViewControllerWithIdentifier:@"idTabBarController"];
    
    // present
    [self presentViewController:privacy animated:YES completion:nil];
    
    // dismiss
    //[self dismissViewControllerAnimated:YES completion:nil];
}

@end