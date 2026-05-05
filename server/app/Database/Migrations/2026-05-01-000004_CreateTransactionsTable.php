<?php

namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;

class CreateTransactionsTable extends Migration
{
    public function up(): void
    {
        $this->forge->addField([
            'id' => [
                'type'       => 'VARCHAR',
                'constraint' => 36,
            ],
            'user_id' => [
                'type'       => 'VARCHAR',
                'constraint' => 36,
            ],
            'account_id' => [
                'type'       => 'VARCHAR',
                'constraint' => 36,
            ],
            'category_id' => [
                'type'       => 'VARCHAR',
                'constraint' => 36,
            ],
            'amount' => [
                'type'       => 'DECIMAL',
                'constraint' => '15,2',
            ],
            'type' => [
                'type'       => 'ENUM',
                'constraint' => ['income', 'expense', 'transfer'],
                'default'    => 'expense',
            ],
            'date' => [
                'type' => 'DATETIME',
            ],
            'note' => [
                'type' => 'TEXT',
                'null' => true,
            ],
            'is_deleted' => [
                'type'    => 'TINYINT',
                'default' => 0,
            ],
            'synced_at' => [
                'type' => 'DATETIME',
                'null' => true,
            ],
            'created_at' => [
                'type' => 'DATETIME',
                'null' => true,
            ],
            'updated_at' => [
                'type' => 'DATETIME',
                'null' => true,
            ],
        ]);

        $this->forge->addKey('id', true);
        $this->forge->addKey('user_id');
        $this->forge->addKey(['user_id', 'date']);    // Composite index for dashboard queries
        $this->forge->createTable('transactions');
    }

    public function down(): void
    {
        $this->forge->dropTable('transactions');
    }
}
