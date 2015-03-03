//
//  DetalleUsuarioSeleccionado2.m
//  prototipo.consulta.cedulas
//
//  Created by Habil on 11/02/15.
//  Copyright (c) 2015 Habil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetalleUsuarioSeleccionado2.h"
@interface DetalleUsuarioSeleccionado2 ()

@property (weak, nonatomic) IBOutlet UILabel *nombreCarrera;
@property (weak, nonatomic) IBOutlet UILabel *nombreEscuela;
@property (weak, nonatomic) IBOutlet UILabel *numeroCedula;
@property (weak, nonatomic) IBOutlet UILabel *nombreCompleto;
@property (weak, nonatomic) IBOutlet UILabel *nombreGenero;
@property (weak, nonatomic) IBOutlet UILabel *anioExpedicion;
@property (weak, nonatomic) IBOutlet UILabel *tipoCedula;

@end

@implementation DetalleUsuarioSeleccionado2

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

@end