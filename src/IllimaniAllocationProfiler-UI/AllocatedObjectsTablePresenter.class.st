Class {
	#name : #AllocatedObjectsTablePresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'tablePresenter',
		'totalAllocations',
		'inputPresenter',
		'objectAllocations'
	],
	#category : #'IllimaniAllocationProfiler-UI-Widgets'
}

{ #category : #initialization }
AllocatedObjectsTablePresenter >> connectPresenters [

	inputPresenter whenTextChangedDo: [ :text | self filterTable: text ]
]

{ #category : #layout }
AllocatedObjectsTablePresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		spacing: 5;
		add: tablePresenter;
		add: inputPresenter expand: false;
		yourself
]

{ #category : #'accessing - model' }
AllocatedObjectsTablePresenter >> filterTable: aText [

	| newItems |
	aText ifEmpty: [
		tablePresenter items: objectAllocations.
		^ self ].
	newItems := objectAllocations select: [ :item |
		item value asString includesSubstring: aText caseSensitive: false ].
	tablePresenter items: newItems
]

{ #category : #initialization }
AllocatedObjectsTablePresenter >> initializePresenters [

	inputPresenter := self newTextInput
		placeholder: 'Filter';
		yourself.
	tablePresenter := self newTable
		alternateRowsColor;
		addColumn: (SpIndexTableColumn new
			title: 'Index';
			beNotExpandable;
			yourself);
		addColumn: (SpStringTableColumn
			title: 'Allocated object class'
			evaluated: #value);
		addColumn: (SpStringTableColumn
			title: 'Allocations'
			evaluated: [ :e | e key asStringWithCommas ]);
		addColumn: (SpStringTableColumn
			title: '%'
			evaluated: [:e |
				(((e key / totalAllocations) * 100) asFloat printShowingDecimalPlaces: 2) , '%']);
		items: objectAllocations;
		yourself
]

{ #category : #'accessing - model' }
AllocatedObjectsTablePresenter >> setModelBeforeInitialization: aModel [

	objectAllocations := (aModel collect: #allocatedObjectClass as: Bag) sortedCounts.
	totalAllocations := objectAllocations sum: [ :a | a key ]
]
